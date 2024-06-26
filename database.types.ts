export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      exerciselog: {
        Row: {
          complete: boolean | null
          id: number
          reps: number | null
          repsinreserve: number | null
          sets: number | null
          workoutid: number | null
        }
        Insert: {
          complete?: boolean | null
          id?: never
          reps?: number | null
          repsinreserve?: number | null
          sets?: number | null
          workoutid?: number | null
        }
        Update: {
          complete?: boolean | null
          id?: never
          reps?: number | null
          repsinreserve?: number | null
          sets?: number | null
          workoutid?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "exerciselog_workoutid_fkey"
            columns: ["workoutid"]
            isOneToOne: false
            referencedRelation: "workout"
            referencedColumns: ["id"]
          },
        ]
      }
      exercises: {
        Row: {
          description: string | null
          id: number
          primary_muscle_group: number | null
        }
        Insert: {
          description?: string | null
          id?: never
          primary_muscle_group?: number | null
        }
        Update: {
          description?: string | null
          id?: never
          primary_muscle_group?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "exercises_musclegroup_fkey"
            columns: ["primary_muscle_group"]
            isOneToOne: false
            referencedRelation: "musclegroup"
            referencedColumns: ["id"]
          },
        ]
      }
      mesocycle: {
        Row: {
          datestart: string | null
          description: string | null
          id: number
          lengthweeks: number | null
        }
        Insert: {
          datestart?: string | null
          description?: string | null
          id?: never
          lengthweeks?: number | null
        }
        Update: {
          datestart?: string | null
          description?: string | null
          id?: never
          lengthweeks?: number | null
        }
        Relationships: []
      }
      musclegroup: {
        Row: {
          description: string | null
          id: number
        }
        Insert: {
          description?: string | null
          id?: never
        }
        Update: {
          description?: string | null
          id?: never
        }
        Relationships: []
      }
      savedworkout: {
        Row: {
          description: string | null
          id: number
          mesocycleid: number | null
        }
        Insert: {
          description?: string | null
          id?: never
          mesocycleid?: number | null
        }
        Update: {
          description?: string | null
          id?: never
          mesocycleid?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "savedworkout_mesocycleid_fkey"
            columns: ["mesocycleid"]
            isOneToOne: false
            referencedRelation: "mesocycle"
            referencedColumns: ["id"]
          },
        ]
      }
      savedworkoutdetail: {
        Row: {
          exerciseid: number | null
          id: number
          repsinreserve: number | null
          savedworkoutid: number | null
          sets: number | null
        }
        Insert: {
          exerciseid?: number | null
          id?: never
          repsinreserve?: number | null
          savedworkoutid?: number | null
          sets?: number | null
        }
        Update: {
          exerciseid?: number | null
          id?: never
          repsinreserve?: number | null
          savedworkoutid?: number | null
          sets?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "savedworkoutdetail_exerciseid_fkey"
            columns: ["exerciseid"]
            isOneToOne: false
            referencedRelation: "exercises"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "savedworkoutdetail_savedworkoutid_fkey"
            columns: ["savedworkoutid"]
            isOneToOne: false
            referencedRelation: "savedworkout"
            referencedColumns: ["id"]
          },
        ]
      }
      workout: {
        Row: {
          date: string | null
          description: string | null
          fatigue_rating: number | null
          id: number
          perceivedeffort: number | null
          uuid: string | null
        }
        Insert: {
          date?: string | null
          description?: string | null
          fatigue_rating?: number | null
          id?: never
          perceivedeffort?: number | null
          uuid?: string | null
        }
        Update: {
          date?: string | null
          description?: string | null
          fatigue_rating?: number | null
          id?: never
          perceivedeffort?: number | null
          uuid?: string | null
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type PublicSchema = Database[Extract<keyof Database, "public">]

export type Tables<
  PublicTableNameOrOptions extends
    | keyof (PublicSchema["Tables"] & PublicSchema["Views"])
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
        Database[PublicTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
      Database[PublicTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : PublicTableNameOrOptions extends keyof (PublicSchema["Tables"] &
        PublicSchema["Views"])
    ? (PublicSchema["Tables"] &
        PublicSchema["Views"])[PublicTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  PublicEnumNameOrOptions extends
    | keyof PublicSchema["Enums"]
    | { schema: keyof Database },
  EnumName extends PublicEnumNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = PublicEnumNameOrOptions extends { schema: keyof Database }
  ? Database[PublicEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : PublicEnumNameOrOptions extends keyof PublicSchema["Enums"]
    ? PublicSchema["Enums"][PublicEnumNameOrOptions]
    : never
