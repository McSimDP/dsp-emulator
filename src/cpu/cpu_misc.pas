unit cpu_misc;

interface
uses {$IFDEF WINDOWS}windows,{$ENDIF}timer_engine,sound_engine,main_engine;

type
     //Call functions
     tgetbyte=function (direccion:word):byte;
     tputbyte=procedure (direccion:word;valor:byte);
     tgetbyte16=function (direccion:dword):byte;
     tputbyte16=procedure (direccion:dword;valor:byte);
     tgetword=function (direccion:dword):word;
     tputword=procedure (direccion:dword;valor:word);
     tdespues_instruccion=procedure (tstates:word);
     cpu_inport_call=function:byte;
     cpu_outport_call=procedure (valor:byte);
     cpu_inport_call16=function:word;
     cpu_outport_call16=procedure (valor:word);
     cpu_inport_full=function(puerto:word):byte;
     cpu_outport_full=procedure (valor:byte;puerto:word);
     cpu_inport_full16=function(puerto:word):word;
     cpu_outport_full16=procedure (valor:word;puerto:word);
     //CPU Master class
     cpu_class=class
          public
            //Misc
            clock:dword;
            contador:integer;
            opcode:boolean;
            numero_cpu:byte;
            tframes:single;
            procedure change_ram_calls(getbyte:tgetbyte;putbyte:tputbyte);
            procedure change_despues_instruccion(despues_instruccion:tdespues_instruccion);
            procedure init_sound(update_call:exec_type);
            procedure change_halt(status:byte);
            procedure change_reset(status:byte);
            function get_halt:byte;
            function get_reset:byte;
            procedure change_irq(estado:byte);
            procedure change_nmi(estado:byte);
            function get_irq:byte;
          protected
            pedir_halt,pedir_reset:byte;
            pedir_nmi,nmi_state:byte;
            pedir_irq,pedir_firq:byte;
            despues_instruccion:tdespues_instruccion;
            estados_demas:word;
            //Llamadas a RAM
            getbyte:tgetbyte;
            putbyte:tputbyte;
        end;

implementation

//IRQ
procedure cpu_class.change_nmi(estado:byte);
begin
if estado=CLEAR_LINE then begin
  self.pedir_nmi:=CLEAR_LINE;
  self.nmi_state:=CLEAR_LINE;
end else begin
  self.pedir_nmi:=estado;
end;
end;

procedure cpu_class.change_irq(estado:byte);
begin
  self.pedir_irq:=estado;
end;

//CPU Calls
procedure cpu_class.change_halt(status:byte);
begin
   self.pedir_halt:=status;
end;

procedure cpu_class.change_reset(status:byte);
begin
   self.pedir_reset:=status;
end;

function cpu_class.get_halt:byte;
begin
   get_halt:=self.pedir_halt;
end;

function cpu_class.get_reset:byte;
begin
   get_reset:=self.pedir_reset;
end;

function cpu_class.get_irq:byte;
begin
  get_irq:=self.pedir_irq;
end;

procedure cpu_class.change_ram_calls(getbyte:tgetbyte;putbyte:tputbyte);
begin
  self.getbyte:=getbyte;
  self.putbyte:=putbyte;
end;

procedure cpu_class.change_despues_instruccion(despues_instruccion:tdespues_instruccion);
begin
  self.despues_instruccion:=despues_instruccion;
end;

procedure cpu_class.init_sound(update_call:exec_type);
begin
sound_engine_init(self.numero_cpu,self.clock,update_call);
end;

end.

