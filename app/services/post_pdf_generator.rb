# app/services/post_pdf_generator.rb
class PostPdfGenerator
  def self.call(post)
    pdf = Prawn::Document.new

    font_path_normal = Rails.root.join("app", "assets", "fonts", "DejaVuSans.ttf").to_s
    font_path_bold = Rails.root.join("app", "assets", "fonts", "DejaVuSans-Bold.ttf").to_s

    pdf.font_families.update(
      "DejaVuSans" => {
        normal: font_path_normal,
        bold: font_path_bold
      }
    )
    pdf.font "DejaVuSans"

    pdf.text "Post: #{post.title}", size: 24, style: :bold
    pdf.move_down 20
    pdf.text post.body, size: 12

    pdf.render # zwraca binarkę PDF
  end
end
