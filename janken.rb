# じゃんけんの選択肢
HANDS = ["グー", "チョキ", "パー", "戦わない"]

# あっち向いてホイの選択肢
DIRECTIONS = ["上", "下", "左", "右", "戦わない"]

# 指定した範囲の数値が入力されるまで繰り返して取得する
def player_choice(message, range)
  loop do
    puts "------------------------------------"
    puts message
    puts "------------------------------------"
    raw = gets

    # Ctrl+D(EOF)でnilの場合は終了
    if raw.nil?
      puts "入力を終了しました"
      exit
    end

    # 改行がある場合、削除
    str = raw.strip

    # 不正入力(文字列/範囲外)を弾く処理を実装
    # 数字だけかチェック
    unless str.match?(/\A\d+\z/)
      puts "エラー: 数字を入力してください"
      next
    end

    # 整数に変換
    value = str.to_i

    # 0~3か確認
    if range.include?(value)
      return value
    end

    puts "エラー: #{range.min}~#{range.max}の数字を入力してください"
  end
end

# じゃんけんを勝敗がつくまで行い、結果を返す
# 戻り値 :player_win/:cpu_win/:quit
def play_janken
  loop do
    puts "【じゃんけん】手を選んでください"
    player_hand = player_choice("0:グー 1:チョキ 2:パー 3:戦わない", (0..3))
    puts "あなた: #{HANDS[player_hand]}"

    # 戦わない場合は終了
    if player_hand == 3
      return :quit
    end

    # CPU
    cpu_hand = rand(0..2)
    puts "相手: #{HANDS[cpu_hand]}"

    if player_hand == cpu_hand #あいこ
      puts "結果: あいこ(もう一回)"
      next
    elsif (player_hand == 0 && cpu_hand == 1) || (player_hand == 1 && cpu_hand == 2) || (player_hand == 2 && cpu_hand == 0) #勝ち
      puts "結果: あなたの勝ち"
      return :player_win
    else #負け
      puts "結果: あなたの負け"
      return :cpu_win
    end
  end
end

# あっち向いてホイを1回行い、次の行動を返す
# 戻り値 :player_win/:cpu_win/:quit/:retry(じゃんけんに戻る)
def play_acchimuite(janken_result)
  if janken_result == :player_win
    puts "【あっち向いてホイ】指す方向を選んでください"
  else
    puts "【あっち向いてホイ】向く方向を選んでください"
  end

  direction_input = player_choice("0:上 1:下 2:左 3:右 4:戦わない", (0..4))
  puts "あなた: #{DIRECTIONS[direction_input]}"

  # 戦わない場合は終了
  if direction_input == 4
    return :quit
  end

  # CPU
  cpu_direction = rand(0..3)
  puts "相手: #{DIRECTIONS[cpu_direction]}"

  if janken_result == :player_win # じゃんけんに勝った場合
    if direction_input == cpu_direction
      puts "結果: あなたの勝ち!"
      return :player_win
    else
      puts "結果: 不一致(じゃんけんに戻る)"
      return :retry
    end
  else # じゃんけんに負けた場合
    if direction_input == cpu_direction
      puts "結果: 相手の勝ち..."
      return :cpu_win
    else
      puts "結果: 不一致(じゃんけんに戻る)"
      return :retry
    end
  end
end

# 全体のループ（不一致ならじゃんけんに戻る）
loop do
  janken_result = play_janken #じゃんけんを実行

  # 終了を選択した場合
  if janken_result == :quit
    puts "終了します"
    break
  end

  acchimuite_result = play_acchimuite(janken_result)  #あっち向いてホイを実行

  # 戦わない/勝負がついたらループを抜ける
  if [:player_win, :cpu_win].include?(acchimuite_result) || acchimuite_result == :quit
    puts "終了します"
    break
  end
  # :retryの場合はループ先頭に戻ってじゃんけんを再開
end