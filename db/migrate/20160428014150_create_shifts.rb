class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|

      t.datetime :start
      t.datetime :end

      t.integer :html, default: 0
      t.integer :js, default: 0
      t.integer :jquery, default: 0
      t.integer :angular, default: 0
      t.integer :ruby, default: 0
      t.integer :rails, default: 0
      t.integer :php, default: 0
      t.integer :python, default: 0
      t.integer :java, default: 0
      t.integer :sql, default: 0
      t.integer :git, default: 0
      t.integer :cmd, default: 0

      t.timestamps null: false
    end
  end
end
