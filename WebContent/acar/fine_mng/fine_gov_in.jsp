<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.res_search.*, acar.user_mng.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	
String vio_dt = "";
String vio_ymd = "";
String vio_s = "";
String vio_m = "";
String vio_pla = "";
String note = "";
String txtTot = "";
int paid_amt = 0;
int tot_amt = 0;

%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
//��������� ���� ���÷���
	function cng_input_findsu(find_su){
		var fm = document.form1;		
		
		var find_su = toInt(find_su) ;
				
		if(find_su >20){
			alert('�Է°����� �ִ�Ǽ��� 20�� �Դϴ�.');
			return;
		}
				
		<%for(int i=0;i <= 20 ;i++){%>
			if(find_su > <%=i%>){
				tr_acct3_<%=i%>_1.style.display	= '';
			}else{
				tr_acct3_<%=i%>_1.style.display	= 'none';
			}
		<%}%>			
			
	}	

function Keyvalue()
 {
  var fm   = document.form1;
  var count = fm.inputCount.value;
  var innTot = 0;
  
  for(i=0; i<count ; i++){
   innTot += toInt(parseDigit(fm.paid_amt[i].value));
  }
  fm.txtTot.value = parseDecimal(innTot);
 }
 

function Keyvalue2()
 {
  var fm   = document.form1;
  var count = fm.inputCount.value;
  var note = '';
  
  for(i=0; i<count ; i++){
// alert(fm.vio_ymd[i].value);
  note +=  fm.vio_ymd[i].value+" "+fm.vio_s[i].value + ":" + fm.vio_m[i].value + ", " + fm.vio_pla[i].value + ", " + fm.paid_amt[i].value + "\n\r" ;
  }
  fm.note.value = note;
 }
	
	

	
function save(){
		var fm = document.form1;
// alert(fm.noteTot.value);
// alert(fm.txtTot.value); 

window.opener.document.form1.note.value=document.getElementById('noteTot').value;
window.opener.document.form1.paid_amt.value=document.getElementById('txtTot').value;
		window.close();
	}

//-->
</script>
</head>
<body>
<form name='form1' action='fine_gov_in.jsp' method='post'>

<table border="0" cellspacing="0" cellpadding="0" width=700>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>���·᳻�� �ϰ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
          			  <td>&nbsp;�� �Է� ��� : <input type="text" name="find_su" value="0" size="2" class="text" id="inputCount" onBlur='javscript:cng_input_findsu(this.value);'>&nbsp;��
          			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>* �Է� ����� 20����� �����մϴ�.</font>
          			  </td> 
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
<% for(int j=0; j<= 20; j++ ){	%>
	<tr id=tr_acct3_<%=j%>_1 style='display:none'>
		<td class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr> 
					<td class=title width='70'>�������</td>
					<td align="center" width='170'><input type="text" name="vio_pla" value="" size="22" id="vio_pla_<%=j%>" class=text maxlength="50" style='IME-MODE: active' ></td>
					<td class=title width='70'>�����Ͻ�</td>
					<td align="center" width='190'><input type="text" name="vio_ymd" value="" size="12" id="vio_ymd_<%=j%>" class=text onBlur='javscript:this.value = ChangeDate(this.value); '>
						<input type="text" name="vio_s" value="" size="2" id="vio_s_<%=j%>" maxlength=2 class=text >��
						<input type="text" name="vio_m" value="" size="2" id="vio_m_<%=j%>" maxlength=2 class=text >��
					</td>
					<td class=title width='70'>���αݾ�</td>
					<td align="center" width='130'><input type="text" name="paid_amt" value="" size="10" id="paid_amt_<%=j%>" maxlength=6 class=num onBlur='javascript:this.value=parseDecimal(this.value); Keyvalue(); Keyvalue2();'>��</td>
				</tr>
			</table>
		</td>
	</tr>
<%}%>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td class="line">
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr> 
					<td class=title width='70'>Ư�̻���</td>
					<td width='430'>&nbsp;<textarea name="note" cols=65 rows=3 id="noteTot" class=default></textarea></td>
					<td class=title width='70'>����</td>
					<td align="center" width='130'><input type="text" name="txtTot" id="txtTot" value="" style="text-align:right;" size="10" class=num >��</td>
				</tr>
			</table>
		</td>
	</tr>
   	<tr>
    	<td class=h></td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:javascript:save()"><img src=../images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;<a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>
