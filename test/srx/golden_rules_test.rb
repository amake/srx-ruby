# frozen_string_literal: true

require 'test_helper'

# Golden Rules adapted from https://github.com/diasks2/pragmatic_segmenter
class GoldenRulesTest < Minitest::Test
  def test_001_simple_period_to_end_sentence
    assert_equal(
      ['Hello World.', 'My name is Jonas.'],
      segment(text: 'Hello World. My name is Jonas.', language: 'en')
    )
  end

  def test_002_question_mark_to_end_sentence
    assert_equal(
      ['What is your name?', 'My name is Jonas.'],
      segment(text: 'What is your name? My name is Jonas.', language: 'en')
    )
  end

  def test_003_exclamation_point_to_end_sentence
    assert_equal(
      ['There it is!', 'I found it.'],
      segment(text: 'There it is! I found it.', language: 'en')
    )
  end

  def test_004_one_letter_upper_case_abbreviations
    skip 'TODO'
    assert_equal(
      ['My name is Jonas E. Smith.'],
      segment(text: 'My name is Jonas E. Smith.', language: 'en')
    )
  end

  def test_005_one_letter_lower_case_abbreviations
    skip 'TODO'
    assert_equal(
      ['Please turn to p. 55.'],
      segment(text: 'Please turn to p. 55.', language: 'en')
    )
  end

  def test_006_two_letter_lower_case_abbreviations_in_the_middle_of_a_sentence
    skip 'TODO'
    assert_equal(
      ['Were Jane and co. at the party?'],
      segment(text: 'Were Jane and co. at the party?', language: 'en')
    )
  end

  def test_007_two_letter_upper_case_abbreviations_in_the_middle_of_a_sentence
    skip 'TODO'
    assert_equal(
      ['They closed the deal with Pitt, Briggs & Co. at noon.'],
      segment(text: 'They closed the deal with Pitt, Briggs & Co. at noon.', language: 'en')
    )
  end

  def test_008_two_letter_lower_case_abbreviations_at_the_end_of_a_sentence
    assert_equal(
      ["Let's ask Jane and co.", 'They should know.'],
      segment(text: "Let's ask Jane and co. They should know.", language: 'en')
    )
  end

  def test_009_two_letter_upper_case_abbreviations_at_the_end_of_a_sentence
    assert_equal(
      ['They closed the deal with Pitt, Briggs & Co.', 'It closed yesterday.'],
      segment(text: 'They closed the deal with Pitt, Briggs & Co. It closed yesterday.', language: 'en')
    )
  end

  def test_010_two_letter_prepositive_abbreviations
    skip 'TODO'
    assert_equal(
      ['I can see Mt. Fuji from here.'],
      segment(text: 'I can see Mt. Fuji from here.', language: 'en')
    )
  end

  def test_011_two_letter_prepositive_and_postpositive_abbreviations
    skip 'TODO'
    assert_equal(
      ["St. Michael's Church is on 5th st. near the light."],
      segment(text: "St. Michael's Church is on 5th st. near the light.", language: 'en')
    )
  end

  def test_012_possesive_two_letter_abbreviations
    assert_equal(
      ["That is JFK Jr.'s book."],
      segment(text: "That is JFK Jr.'s book.", language: 'en')
    )
  end

  def test_013_multi_period_abbreviations_in_the_middle_of_a_sentence
    skip 'TODO'
    assert_equal(
      ['I visited the U.S.A. last year.'],
      segment(text: 'I visited the U.S.A. last year.', language: 'en')
    )
  end

  def test_014_multi_period_abbreviations_at_the_end_of_a_sentence
    assert_equal(
      ['I live in the E.U.', 'How about you?'],
      segment(text: 'I live in the E.U. How about you?', language: 'en')
    )
  end

  def test_015_u_s_as_sentence_boundary
    assert_equal(
      ['I live in the U.S.', 'How about you?'],
      segment(text: 'I live in the U.S. How about you?', language: 'en')
    )
  end

  def test_016_u_s_as_non_sentence_boundary_with_next_word_capitalized
    skip 'TODO'
    assert_equal(
      ['I work for the U.S. Government in Virginia.'],
      segment(text: 'I work for the U.S. Government in Virginia.', language: 'en')
    )
  end

  def test_017_u_s_as_non_sentence_boundary
    skip 'TODO'
    assert_equal(
      ['I have lived in the U.S. for 20 years.'],
      segment(text: 'I have lived in the U.S. for 20 years.', language: 'en')
    )
  end

  def test_018_am_pm_as_non_sentence_boundary_and_sentence_boundary
    skip 'TODO'
    assert_equal(
      ['At 5 a.m. Mr. Smith went to the bank.', 'He left the bank at 6 P.M.', 'Mr. Smith then went to the store.'],
      segment(
        text: 'At 5 a.m. Mr. Smith went to the bank. He left the bank at 6 P.M. Mr. Smith then went to the store.',
        language: 'en'
      )
    )
  end

  def test_019_number_as_non_sentence_boundary
    assert_equal(
      ['She has $100.00 in her bag.'],
      segment(text: 'She has $100.00 in her bag.', language: 'en')
    )
  end

  def test_020_number_as_sentence_boundary
    assert_equal(
      ['She has $100.00.', 'It is in her bag.'],
      segment(text: 'She has $100.00. It is in her bag.', language: 'en')
    )
  end

  def test_021_parenthetical_inside_sentence
    assert_equal(
      ['He teaches science (He previously worked for 5 years as an engineer.) at the local University.'],
      segment(
        text: 'He teaches science (He previously worked for 5 years as an engineer.) at the local University.',
        language: 'en'
      )
    )
  end

  def test_022_email_addresses
    assert_equal(
      ['Her email is Jane.Doe@example.com.', 'I sent her an email.'],
      segment(text: 'Her email is Jane.Doe@example.com. I sent her an email.', language: 'en')
    )
  end

  def test_023_web_addresses
    assert_equal(
      ['The site is: https://www.example.50.com/new-site/awesome_content.html.', 'Please check it out.'],
      segment(
        text: 'The site is: https://www.example.50.com/new-site/awesome_content.html. Please check it out.',
        language: 'en'
      )
    )
  end

  def test_024_single_quotations_inside_sentence
    assert_equal(
      ["She turned to him, 'This is great.' she said."],
      segment(text: "She turned to him, 'This is great.' she said.", language: 'en')
    )
  end

  def test_025_double_quotations_inside_sentence
    assert_equal(
      ['She turned to him, "This is great." she said.'],
      segment(text: 'She turned to him, "This is great." she said.', language: 'en')
    )
  end

  def test_026_double_quotations_at_the_end_of_a_sentence
    skip 'TODO'
    assert_equal(
      ['She turned to him, "This is great."', 'She held the book out to show him.'],
      segment(text: 'She turned to him, "This is great." She held the book out to show him.', language: 'en')
    )
  end

  def test_027_double_punctuation_exclamation_point
    assert_equal(
      ['Hello!!', 'Long time no see.'],
      segment(text: 'Hello!! Long time no see.', language: 'en')
    )
  end

  def test_028_double_punctuation_question_mark
    assert_equal(
      ['Hello??', 'Who is there?'],
      segment(text: 'Hello?? Who is there?', language: 'en')
    )
  end

  def test_029_double_punctuation_exclamation_point_question_mark
    assert_equal(
      ['Hello!?', 'Is that you?'],
      segment(text: 'Hello!? Is that you?', language: 'en')
    )
  end

  def test_030_double_punctuation_question_mark_exclamation_point
    assert_equal(
      ['Hello?!', 'Is that you?'],
      segment(text: 'Hello?! Is that you?', language: 'en')
    )
  end

  def test_031_list_period_followed_by_parens_and_no_period_to_end_item
    skip 'TODO'
    assert_equal(
      ['1.) The first item', '2.) The second item'],
      segment(text: '1.) The first item 2.) The second item', language: 'en')
    )
  end

  def test_032_list_period_followed_by_parens_and_period_to_end_item
    assert_equal(
      ['1.) The first item.', '2.) The second item.'],
      segment(text: '1.) The first item. 2.) The second item.', language: 'en')
    )
  end

  def test_033_list_parens_and_no_period_to_end_item
    skip 'TODO'
    assert_equal(
      ['1) The first item', '2) The second item'],
      segment(text: '1) The first item 2) The second item', language: 'en')
    )
  end

  def test_034_list_parens_and_period_to_end_item
    assert_equal(
      ['1) The first item.', '2) The second item.'],
      segment(text: '1) The first item. 2) The second item.', language: 'en')
    )
  end

  def test_035_list_period_to_mark_list_and_no_period_to_end_item
    skip 'TODO'
    assert_equal(
      ['1. The first item', '2. The second item'],
      segment(text: '1. The first item 2. The second item', language: 'en')
    )
  end

  def test_036_list_period_to_mark_list_and_period_to_end_item
    skip 'TODO'
    assert_equal(
      ['1. The first item.', '2. The second item.'],
      segment(text: '1. The first item. 2. The second item.', language: 'en')
    )
  end

  def test_037_list_with_bullet
    skip 'TODO'
    assert_equal(
      ['• 9. The first item', '• 10. The second item'],
      segment(text: '• 9. The first item • 10. The second item', language: 'en')
    )
  end

  def test_038_list_with_hyphen
    skip 'TODO'
    assert_equal(
      ['⁃9. The first item', '⁃10. The second item'],
      segment(text: '⁃9. The first item ⁃10. The second item', language: 'en')
    )
  end

  def test_039_alphabetical_list
    skip 'TODO'
    assert_equal(
      ['a. The first item', 'b. The second item', 'c. The third list item'],
      segment(text: 'a. The first item b. The second item c. The third list item', language: 'en')
    )
  end

  def test_040_errant_newlines_in_the_middle_of_sentences_pdf
    skip 'TODO'
    assert_equal(
      ['This is a sentence cut off in the middle because pdf.'],
      segment(text: "This is a sentence\ncut off in the middle because pdf.", language: 'en', doc_type: 'pdf')
    )
  end

  def test_041_errant_newlines_in_the_middle_of_sentences
    skip 'TODO'
    assert_equal(
      ['It was a cold night in the city.'],
      segment(text: "It was a cold \nnight in the city.", language: 'en')
    )
  end

  def test_042_lower_case_list_separated_by_newline
    assert_equal(
      ['features', 'contact manager', 'events, activities'],
      segment(text: "features\ncontact manager\nevents, activities\n", language: 'en')
    )
  end

  def test_043_geo_coordinates
    skip 'TODO'
    assert_equal(
      ['You can find it at N°. 1026.253.553.', 'That is where the treasure is.'],
      segment(text: 'You can find it at N°. 1026.253.553. That is where the treasure is.', language: 'en')
    )
  end

  def test_044_named_entities_with_an_exclamation_point
    skip 'TODO'
    assert_equal(
      ['She works at Yahoo! in the accounting department.'],
      segment(text: 'She works at Yahoo! in the accounting department.', language: 'en')
    )
  end

  def test_045_i_as_a_sentence_boundary_and_i_as_an_abbreviation
    skip 'TODO'
    assert_equal(
      ['We make a good team, you and I.', 'Did you see Albert I. Jones yesterday?'],
      segment(text: 'We make a good team, you and I. Did you see Albert I. Jones yesterday?', language: 'en')
    )
  end

  def test_046_ellipsis_at_end_of_quotation
    skip 'TODO'
    assert_equal(
      ['Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .”'],
      segment(text: <<~TXT.chomp, language: 'en')
        Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .”
      TXT
    )
  end

  def test_047_ellipsis_with_square_brackets
    assert_equal(
      ['"Bohr [...] used the analogy of parallel stairways [...]" (Smith 55).'],
      segment(text: '"Bohr [...] used the analogy of parallel stairways [...]" (Smith 55).', language: 'en')
    )
  end

  def test_048_ellipsis_as_sentence_boundary_standard_ellipsis_rules
    skip 'TODO'
    assert_equal(
      [
        <<~TXT.chomp,
          If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . .'
        TXT
        'Next sentence.'
      ],
      segment(text: <<~TXT.chomp, language: 'en')
        If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . . Next sentence.
      TXT
    )
  end

  def test_049_ellipsis_as_sentence_boundary_non_standard_ellipsis_rules
    assert_equal(
      ['I never meant that....', 'She left the store.'],
      segment(text: 'I never meant that.... She left the store.', language: 'en')
    )
  end

  def test_050_ellipsis_as_non_sentence_boundary
    skip 'TODO'
    assert_equal(
      ["I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it."],
      segment(
        text: "I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it.",
        language: 'en'
      )
    )
  end

  def test_051_4_dot_ellipsis
    skip 'TODO'
    assert_equal(
      [
        <<~TXT.chomp,
          One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds.
        TXT
        '. . . The practice was not abandoned. . . .'
      ],
      segment(text: <<~TXT.chomp, language: 'en')
        One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds. . . . The practice was not abandoned. . . .
      TXT
    )
  end

  private

  def segment(text:, language:, **_kwargs)
    sample_engine.segment(text, lang_code: language).map(&:strip)
  end

  def sample_engine
    data = File.open('test/srx-20-sample.srx') { |f| Srx::Data.from_io(f) }
    Srx::Engine.new(data)
  end
end
