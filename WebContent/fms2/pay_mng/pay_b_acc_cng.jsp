<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
	String vid[] 	= request.getParameterValues("ch_cd");
	String reqseq 	= "";
	
	int vid_size = vid.length;
	
	
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	//�����縮��Ʈ
	Vector bank_vt =  ps_db.getCodeList("0003");
	int bank_size = bank_vt.size();
	
	//������¹�ȣ
	Vector accs = ps_db.getDepositList();
	int acc_size = accs.size();
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//��ݹ�� ����		
	function save()
	{
		var fm = document.form1;
		
		//�����̸鼭 ��ü���� �ִ°� üũ
		if(fm.p_way[0].checked == true && fm.bank_no.value != ''){
			alert('��ݹ���� �����ε� �Աݰ��¹�ȣ�� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); 
			return;
		}
		
		if(fm.s_bank_id.options[fm.s_bank_id.selectedIndex].value != ''){
			fm.bank_nm.value = fm.s_bank_id.options[fm.s_bank_id.selectedIndex].text;
		}
		
		if(confirm('�����Ͻðڽ��ϱ�?')){
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
			
			fm.action = 'pay_b_acc_cng_a.jsp';
			fm.target = 'i_no';
			fm.submit();
			
      link.getAttribute('href',originFunc);					
		}
	}	
	
	//�۱ݹ�� ����
	function save2()
	{
		var fm = document.form1;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){
			fm.action = 'pay_b_acc_cng_a2.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}
	}		
	
	//�׿�����ȸ-�ſ�ī��
	function Neom_search(s_kd){
		var fm = document.form1;	
		if(fm.card_no.value != '')	fm.t_wd.value = fm.card_no.value;
		window.open("/card/doc_reg/neom_search.jsp?go_url=/fms2/pay_mng/pay_dir_reg.jsp&s_kd="+s_kd+"&t_wd="+fm.t_wd.value, "Neom_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		
	}
	function Neom_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search(s_kd);
	}		
	
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>      
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='<%=from_page%>'>  
  <input type='hidden' name='bank_nm' value=''>      
<%for(int i=0;i < vid_size;i++){
		reqseq = vid[i];%>		
  <input type='hidden' name='reqseq' 	value='<%=reqseq%>'>
<%	}%>

  <table width="800" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>
						��ݿ������</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
      <td class=h></td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 	
	<tr>
	  <td>�� ��ݹ�� ����</td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="15%" class=title>��ݹ��</td>
            <td>&nbsp;
			    <input type='radio' name="p_way" value='1'  >
				����
				<input type='radio' name="p_way" value='2' >
				����ī��
				<input type='radio' name="p_way" value='3' >
				�ĺ�ī��				
				<input type='radio' name="p_way" value='4'  >
				�ڵ���ü
				<input type='radio' name="p_way" value='5' checked >
                		������ü
                <input type='radio' name="p_way" value='7' >
				ī���Һ�		
				</td>
          </tr>
          <tr>
            <td class=title>�Ա�����</td>
            <td >&nbsp;			  
			  <select name='s_bank_id'>
                        <option value=''>����</option>
                        <%	for(int i = 0 ; i < bank_size ; i++){
								Hashtable bank_ht = (Hashtable)bank_vt.elementAt(i);%>
                        <option value='<%= bank_ht.get("BANK_ID")%>' ><%= bank_ht.get("NM")%></option>
                        <%	}%>
              </select>&nbsp;
              <input type='text' name='bank_no' size='30' value='' class='default' >       
			  &nbsp;������ : <input type='text' name='bank_acc_nm' size='33' value='' class='default' >      
			  <input type='hidden' name='bank_id' 	value=''> 
			</td>
          </tr>		
          <tr>
            <td class=title>��ݰ���</td>
            <td >&nbsp;
			  <select name='deposit_no'>
                <option value=''>���¸� �����ϼ���</option>
                <%	if(acc_size > 0){
										for(int i = 0 ; i < acc_size ; i++){
											Hashtable acc = (Hashtable)accs.elementAt(i);%>
                <option value='<%= acc.get("DEPOSIT_NO")%>' >[<%=acc.get("CHECKD_NAME")%>]<%= acc.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= acc.get("DEPOSIT_NAME")%></option>
                <%		}
									}%>
              </select> 
			  &nbsp;
			  (�Ƹ���ī ����, <font color="#FF0000">�ڵ���ü�� ��</font>) 
            </td>
          </tr>		
          <tr>
            <td class=title>����ī��</td>
            <td >&nbsp;
			  <input name="card_no" type="text" class="text" value="" size="30" style='IME-MODE: active' onKeyDown="javascript:Neom_enter('cardno')" >
              &nbsp;<a href="javascript:Neom_search('cardno');" ><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>&nbsp;(ī���ȣ/����ڸ����� �˻�)
			  <input type='hidden' name='card_id' 	value=''>
			  <input type='hidden' name='card_nm' 	value=''>									
            </td>
          </tr>		      	  
		</table>
	  </td>
	</tr> 				
    <tr>
	    <td align='center'>
	    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
	    <%}%>
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>		
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 	
	<tr>
	  <td>�� �۱ݹ�� ����</td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="15%" class=title>�۱����տ���</td>
            <td>&nbsp;
			    <input type='radio' name="act_union_yn" value='N' >
				�����۱�
				<input type='radio' name="act_union_yn" value='Y' checked >
                ���ռ۱� (���� ����ó�� ��� �۱�ó��)
				</td>
          </tr>      	  
		</table>
	  </td>
	</tr> 				
    <tr>
	    <td align='center'>
	    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save2()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
	    <%}%>
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>		
  </table>
</form>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

