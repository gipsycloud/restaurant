class NormalizeTableStatusValues < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      UPDATE tables
      SET status = CASE status
        WHEN '0' THEN 'available'
        WHEN '1' THEN 'occupied'
        WHEN '2' THEN 'reserved'
        ELSE status
      END
      WHERE status IN ('0', '1', '2');
    SQL
  end

  def down
    execute <<~SQL
      UPDATE tables
      SET status = CASE status
        WHEN 'available' THEN '0'
        WHEN 'occupied' THEN '1'
        WHEN 'reserved' THEN '2'
        ELSE status
      END
      WHERE status IN ('available', 'occupied', 'reserved');
    SQL
  end
end
