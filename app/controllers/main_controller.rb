class MainController < ApplicationController
  def index

  end

  def import
    servers_file = params[:servers_file]
    inspec_file = params[:inspec_file]
    servers = File.read(servers_file.path)
    csv = CSV.parse(servers)

    rowarray = Array.new
    queue = Queue.new
    threads = Array.new

    csv.each do |row|
      test_unit = {
          "command" => "inspec exec #{inspec_file.path} -t #{row[0]} --password \"#{row[1]}\" --reporter json-min",
          "server_name" => row[0]
      }
      queue.push(test_unit)
    end

    4.times do
      threads << Thread.new do
        until queue.empty?
          work_unit = queue.pop(true) rescue nil
          if work_unit
            @total_service_fail = 0
            @total_service_success = 0
            @total_server_error = 0
            @total_server_success = 0

            print work_unit
            inspec_reports_json = `#{work_unit["command"]}`

            reports = JSON.parse(inspec_reports_json)

            reports['server_name'] = work_unit["server_name"]

            reports['controls'].each do |report|
              if report['status'] == 'failed'
                @total_service_fail += 1
                @server_with_error = true
              else
                @total_service_success += 1
              end
            end

            if @server_with_error
              @total_server_error += 1
            else
              @total_server_success += 1
            end
            rowarray << reports
          end
        end
      end
    end

    threads.each {
        |t| t.join;
      @rowarraydisp = rowarray
    }

  end

end
