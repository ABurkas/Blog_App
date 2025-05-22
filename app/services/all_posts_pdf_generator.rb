class AllPostsPdfGenerator
  def self.call
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

    pdf.text "Wszystkie posty", size: 24, style: :bold
    pdf.move_down 20

    Post.order(created_at: :desc).each_with_index do |post, index|
      pdf.text "#{index + 1}. #{post.title}", size: 16, style: :bold
      pdf.move_down 5
      pdf.text post.body, size: 12
      pdf.move_down 15
    end

    pdf.render
  end
end
