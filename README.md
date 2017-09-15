popen3-test.rb
====

    $ ./popen3-test.rb
    ProcessServer.log():start() cmd=/bin/ping www.google.com
    p.is_running=true
    "PING www.google.com (216.58.197.228): 56 data bytes\n"
    "64 bytes from 216.58.197.228: seq=0 ttl=49 time=7.322 ms\n"
    "64 bytes from 216.58.197.228: seq=1 ttl=49 time=4.088 ms\n"
    "64 bytes from 216.58.197.228: seq=2 ttl=49 time=4.044 ms\n"
    ProcessServer.log():stop()
    p.is_running=false

code:

    Open3.popen3(@cmd) do |stdin, stdout, stderr, wait_thread|
      begin
        loop do
          IO.select([stdout, stderr]).flatten.compact.each do |io|
            io.each do |line|
              next if line.nil? || line.empty?
                @on_recieve_block.call(line) unless @on_recieve_block.nil?
              end
            end
            break if stdout.eof? && stderr.eof?
          end
          rescue Exception => e
            log "IO object closed...e=" + e.inspect
          end
        end
        @wait_thread.join                      # ← 実行が続くコマンドの場合、ここを忘れるとブロックをすぐ抜けていきなりstdoutなどがcloseされるので要注意… 
        loop do
          break if stdout.eof? && stderr.eof?  # ← 起動したプログラムの出力が多い場合、バッファをreadする前に子プロセスが終了すると、ブロックを抜けた瞬間にIOオブジェクトがcloseして、内容を全部読み取れないことがあるので要注意…
          sleep 1
        end
      rescue Exception => e
        log "spawn failed...e=" + e.inspect
      end
    end

Reference
----
module function Open3.#popen3 (Ruby 2.4.0)
* https://docs.ruby-lang.org/ja/latest/method/Open3/m/popen3.html

class Process::Status (Ruby 2.4.0)
* https://docs.ruby-lang.org/ja/latest/class/Process=3a=3aStatus.html

Copyright and license
----
Copyright (c) 2017 yoggy

Released under the [MIT license](LICENSE.txt)
