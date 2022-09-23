*&---------------------------------------------------------------------*
*& Report z01_black_jack
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_black_jack.

TYPES: BEGIN OF t_card,
         name  TYPE string,
         value TYPE i,
         color TYPE string,
       END OF t_card.

TYPES t_cards TYPE STANDARD TABLE OF t_card WITH DEFAULT KEY.

DATA(cards) = VALUE t_cards(
  ( name = `2` value = 2 color = `Black Spades` )
  ( name = `3` value = 3 color = `Black Spades` )
  ( name = `4` value = 4 color = `Black Spades` )
  ( name = `5` value = 5 color = `Black Spades` )
  ( name = `6` value = 6 color = `Black Spades` )
  ( name = `7` value = 7 color = `Black Spades` )
  ( name = `8` value = 8 color = `Black Spades` )
  ( name = `9` value = 9 color = `Black Spades` )
  ( name = `10` value = 10 color = `Black Spades` )
  ( name = `Jack` value = 10 color = `Black Spades`  )
  ( name = `Queen` value = 10 color = `Black Spades` )
  ( name = `King` value = 10 color = `Black Spades` )
  ( name = `Ace` value = 11 color = `Black Spades` )
  ( name = `2` value = 2 color = `Red Hearts` )
  ( name = `3` value = 3 color = `Red Hearts` )
  ( name = `4` value = 4 color = `Red Hearts` )
  ( name = `5` value = 5 color = `Red Hearts` )
  ( name = `6` value = 6 color = `Black Spades` )
  ( name = `7` value = 7 color = `Red Hearts` )
  ( name = `8` value = 8 color = `Red Hearts` )
  ( name = `9` value = 9 color = `Red Hearts` )
  ( name = `10` value = 10 color = `Red Hearts` )
  ( name = `Jack` value = 10 color = `Red Hearts`  )
  ( name = `Queen` value = 10 color = `Red Hearts` )
  ( name = `King` value = 10 color = `Red Hearts` )
  ( name = `Ace` value = 11 color = `Red Hearts` )
  ( name = `2` value = 2 color = `Blue Diamonds` )
  ( name = `3` value = 3 color = `Blue Diamonds` )
  ( name = `4` value = 4 color = `Blue Diamonds` )
  ( name = `5` value = 5 color = `Blue Diamonds` )
  ( name = `6` value = 6 color = `Blue Diamonds` )
  ( name = `7` value = 7 color = `Blue Diamonds` )
  ( name = `8` value = 8 color = `Blue Diamonds` )
  ( name = `9` value = 9 color = `Blue Diamonds` )
  ( name = `10` value = 10 color = `Blue Diamonds` )
  ( name = `Jack` value = 10 color = `Blue Diamonds`  )
  ( name = `Queen` value = 10 color = `Blue Diamonds` )
  ( name = `King` value = 10 color = `Blue Diamonds` )
  ( name = `Ace` value = 11 color = `Blue Diamonds` )
  ( name = `2` value = 2 color = `Green Clubs` )
  ( name = `3` value = 3 color = `Green Clubs` )
  ( name = `4` value = 4 color = `Green Clubs` )
  ( name = `5` value = 5 color = `Green Clubs` )
  ( name = `6` value = 6 color = `Green Clubs` )
  ( name = `7` value = 7 color = `Green Clubs` )
  ( name = `8` value = 8 color = `Green Clubs` )
  ( name = `9` value = 9 color = `Green Clubs` )
  ( name = `10` value = 10 color = `Green Clubs` )
  ( name = `Jack` value = 10 color = `Green Clubs`  )
  ( name = `Queen` value = 10 color = `Green Clubs` )
  ( name = `King` value = 10 color = `Green Clubs` )
  ( name = `Ace` value = 11 color = `Green Clubs` )
).

TRY.
    DATA(randomizer) = cl_abap_random=>create( ).

    DATA(is_player_playing) = abap_true.
    DATA(player_score) = 0.

    DATA(is_croupier_playing) = abap_true.
    DATA(croupier_score) = 0.

    WHILE is_player_playing = abap_true.
      DATA(card_index) = randomizer->intinrange( low = 1 high = lines( cards ) ).
      DATA(card) = cards[ card_index ].
      DELETE cards INDEX card_index.

      IF card-name = 'ACE'.
        IF player_score > 11.
          player_score += 1.
        ELSE.
          player_score += 10.
        ENDIF.
      ELSE.
        player_score += card-value.
      ENDIF.

      IF player_score <= 21.
        DATA(message) = |You have got a { card-color && card-name }. Your current score is { player_score }|
                        && |Do you want to have 1 more card?|.
        DATA popup_return TYPE char01.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = 'What is your next action?'
            text_question         = message
            text_button_1         = 'Hit'
            text_button_2         = 'Stand'
            display_cancel_button = abap_false
          IMPORTING
            answer                = popup_return " to hold the FM's return value
          EXCEPTIONS
            text_not_found        = 1
            OTHERS                = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

        IF popup_return EQ '2'.
          is_player_playing = abap_false.
        ENDIF.
      ELSE.
        is_player_playing = abap_false.
      ENDIF.
    ENDWHILE.

    WRITE: / |Your score is { player_score }|.

    WHILE is_croupier_playing = abap_true.
      card_index = randomizer->intinrange( low = 1 high = lines( cards ) ).
      card = cards[ card_index ].
      DELETE cards INDEX card_index.

      croupier_score += card-value.

      IF croupier_score > 16.
        is_croupier_playing = abap_false.
      ENDIF.
    ENDWHILE.

    WRITE: / |Croupier`s score is { croupier_score }|.
    IF croupier_score > 21 OR ( player_score <= 21 AND player_score > croupier_score ).
      WRITE: / |Player has won|.
    ELSE.
      WRITE: / |Croupier has won|.
    ENDIF.
  CATCH cx_abap_random.
    WRITE: |An error occurred!|.
ENDTRY.
