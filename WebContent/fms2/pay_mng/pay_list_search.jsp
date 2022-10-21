<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.bill_mng.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String pay_gubun_nm	= request.getParameter("pay_gubun_nm")	==null?"":request.getParameter("pay_gubun_nm");
	String pay_gubun 	= request.getParameter("pay_gubun")	==null?"":request.getParameter("pay_gubun");
	String pay_est_dt	= request.getParameter("pay_est_dt")	==null?AddUtil.getDate():request.getParameter("pay_est_dt");
	String pay_est_dt2	= request.getParameter("pay_est_dt2")	==null?AddUtil.getDate():request.getParameter("pay_est_dt2");
	String pay_off		= request.getParameter("pay_off")	==null?"":request.getParameter("pay_off");
	
	//���ǰ˻�
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String st_dt 		= request.getParameter("st_dt")		==null?pay_est_dt:request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?pay_est_dt2:request.getParameter("end_dt");
	String yet_again 	= request.getParameter("yet_again")	==null?"N":request.getParameter("yet_again");
	String vid_size 	= request.getParameter("vid_size")	==null?"":request.getParameter("vid_size");
	String h_cnt	 	= request.getParameter("h_cnt")	==null?"":request.getParameter("h_cnt");
	
	
	
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Vector vt = new Vector();
	
	if(pay_gubun.equals("01")) 	vt = ps_db.getPayEstAmt01List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("02")) 	vt = ps_db.getPayEstAmt02List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("03")) 	vt = ps_db.getPayEstAmt03_2List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("04")) 	vt = ps_db.getPayEstAmt04List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("05")) 	vt = ps_db.getPayEstAmt05List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("06")) 	vt = ps_db.getPayEstAmt06List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("07")) 	vt = ps_db.getPayEstAmt07List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("08")) 	vt = ps_db.getPayEstAmt08List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("11")) 	vt = ps_db.getPayEstAmt11List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("12")) 	vt = ps_db.getPayEstAmt12_2List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("13")) 	vt = ps_db.getPayEstAmt13_2List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("17")) 	vt = ps_db.getPayEstAmt17_2List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("21")) 	vt = ps_db.getPayEstAmt21List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("22")) 	vt = ps_db.getPayEstAmt22_2List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("23")) 	vt = ps_db.getPayEstAmt23_2List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("24")) 	vt = ps_db.getPayEstAmt24_2List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("25")) 	vt = ps_db.getPayEstAmt25List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("31")) 	vt = ps_db.getPayEstAmt31List	(s_kd, t_wd, st_dt, pay_off, yet_again);//���������ȯ��
	if(pay_gubun.equals("41")) 	vt = ps_db.getPayEstAmt41List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("14")) 	vt = ps_db.getPayEstAmt14List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("15")) 	vt = ps_db.getPayEstAmt15List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("16")) 	vt = ps_db.getPayEstAmt16List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("18")) 	vt = ps_db.getPayEstAmt18List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("19")) 	vt = ps_db.getPayEstAmt19List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("42")) 	vt = ps_db.getPayEstAmt42List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("43")) 	vt = ps_db.getPayEstAmt43List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("44")) 	vt = ps_db.getPayEstAmt44List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("45")) 	vt = ps_db.getPayEstAmt45List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("46")) 	vt = ps_db.getPayEstAmt46List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("47")) 	vt = ps_db.getPayEstAmt47List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("48")) 	vt = ps_db.getPayEstAmt48List	(s_kd, t_wd, st_dt, pay_off, yet_again);
	if(pay_gubun.equals("33")) 	vt = ps_db.getPayEstAmt33List	(s_kd, t_wd, st_dt, pay_off, yet_again);//���°躸���ݽ°�
	if(pay_gubun.equals("34")) 	vt = ps_db.getPayEstAmt34List	(s_kd, t_wd, st_dt, pay_off, yet_again);//�����°躸���ݽ°�
	if(pay_gubun.equals("35")) 	vt = ps_db.getPayEstAmt35List	(s_kd, t_wd, st_dt, pay_off, yet_again);//���°躸����ȯ��
	if(pay_gubun.equals("51")) 	vt = ps_db.getPayEstAmt51List	(s_kd, t_wd, st_dt, pay_off, yet_again);//ķ��������
	if(pay_gubun.equals("52")) 	vt = ps_db.getPayEstAmt52List	(s_kd, t_wd, st_dt, pay_off, yet_again);//��������
	if(pay_gubun.equals("53")) 	vt = ps_db.getPayEstAmt53List	(s_kd, t_wd, st_dt, pay_off, yet_again);//���⿩��
	if(pay_gubun.equals("54")) 	vt = ps_db.getPayEstAmt54List	(s_kd, t_wd, st_dt, pay_off, yet_again);//���ͳݴ�����
	if(pay_gubun.equals("55")) 	vt = ps_db.getPayEstAmt55List	(s_kd, t_wd, st_dt, end_dt, pay_off, yet_again);//������
	if(pay_gubun.equals("36")) 	vt = ps_db.getPayEstAmt36List	(s_kd, t_wd, st_dt, pay_off, yet_again);//�����ຸ����ȯ��
	if(pay_gubun.equals("37")) 	vt = ps_db.getPayEstAmt37List	(s_kd, t_wd, st_dt, pay_off, yet_again);//����Ʈ�����ȯ��
	
	int vt_size = vt.size();
	
	long t_amt = 0;
	
	
	//20150622  Form parameter-count '10001' exceeded parameter-max '10000' ������ �ִ� 200 �ϸ� 10000 ���� ����.
	//if(vt_size > 200) vt_size = 200;
	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search()
	{
		var fm = document.form1;
		fm.action = 'pay_list_search.jsp';
		fm.target = '_self';
		fm.submit();		
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		
		setSamt();
		return;
	}			
	
	//Ȯ��
	function save(){
		var fm = document.form1;	
		var cnt=0;
		var idnum="";
		
		
		for(var i=0 ; i<toInt(fm.size.value) ; i++){
		  if(toInt(fm.size.value)>1){
				if(fm.ch_cd[i].checked == true){
					cnt++;
					idnum=fm.ch_cd[i].value;
				}
      }else{
				if(fm.ch_cd.checked == true){
					cnt++;
					idnum=fm.ch_cd.value;
				}
      }
		}			
		if(cnt == 0){
		 	alert("1�� �̻� �����ϼ���.");
			return;
		}	
				
		fm.mode.value = "search";

		//���ʼ���
		if(fm.vid_size.value == '0'){
			fm.target = "d_content";
			fm.action = "pay_list_reg.jsp";
			fm.submit();	
			self.window.close();
		//�߰�����	
		}else{
			if(confirm('����ó�� ���� ��쿡�� ����ó�� �˴ϴ�. ����Ͻðڽ��ϱ�?')){			
				fm.target = "_self";
				fm.action = "pay_list_reg_set.jsp";
				fm.submit();
			}
		}
		
	}				
	
	//Ȯ��
	function save04(){
		var fm = document.form1;	
		fm.mode.value = "search";
		fm.target = "d_content";
		fm.action = "pay_list_reg.jsp";
		fm.submit();	
		
		self.window.close();
	}					
			
	//���ñݾ�
	function setSamt(){
		var fm = document.form1;	
		var s_amt = 0;
		for(var i=0 ; i<toInt(fm.size.value) ; i++){
		  if(toInt(fm.size.value)>1){
				if(fm.ch_cd[i].checked == true){
					s_amt = s_amt + toInt(parseDigit(fm.amt[i].value));
				}
      }else{
				if(fm.ch_cd.checked == true){
					s_amt = s_amt + toInt(parseDigit(fm.amt.value));
				}
      }
		}
		fm.s_amt.value = parseDecimal(s_amt);
	}
	
	function set_select_cnt(){
		var fm = document.form1;
		var s_cnt = toInt(fm.select_cnt.value);
		for(var i=0; i<s_cnt; i++){
			fm.ch_cd[i].checked = true;
		}
		for(var i=s_cnt; i<toInt(fm.size.value); i++){
			fm.ch_cd[i].checked = false;
		}
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' target='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='pay_gubun' value='<%=pay_gubun%>'>
<input type='hidden' name='pay_gubun_nm' value='<%=pay_gubun_nm%>'>
<input type='hidden' name='vid_size' value='<%=vid_size%>'>
<input type='hidden' name='h_cnt' value='<%=h_cnt%>'>
<input type='hidden' name='mode' value=''>


  <table border='0' cellspacing='0' cellpadding='0' width='1150'>
    <tr>
      <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ��ݿ����� > <span class=style5><%=pay_gubun_nm%> ��ȸ</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td align="right">&nbsp;<%if(ck_acar_id.equals("000029")){%>
                    	<%	if(pay_gubun.equals("07")||pay_gubun.equals("08")){%>
                    	1���� <input type='text' name='select_cnt' size='3' class='text' value='<%=vt_size%>'>���� <a href="javascript:set_select_cnt()" onMouseOver="window.status=''; return true" onfocus="this.blur()">����</a>
                    	<%	}%>
                    	<%}%></td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>	
    <tr>
        <td class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=8%>��������</td>
                    <td width=13%>&nbsp;
            		    <input type='text' size='12' name='pay_est_dt' class='text' value='<%=pay_est_dt%>'>
						<%if(pay_gubun.equals("55")){%>
						<br>&nbsp;&nbsp;
						~
						<input type='text' size='12' name='pay_est_dt2' class='text' value='<%=pay_est_dt2%>'>
						<%}%>
        		    </td>
                    <td class=title width=8%>����ó</td>
                    <td width=15%>&nbsp;
            		    <input type='text' size='20' name='pay_off' class='text' value='<%=pay_off%>'>
        		    </td>
                    <td class=title width=8%>�˻�����</td>
                    <td width=28%>&nbsp;					
            	      <select name='s_kd'>
			  <%if(pay_gubun.equals("01")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ȣ </option>
			  <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>
			  <%}else if(pay_gubun.equals("02")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ȣ </option>						  
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>������� </option>
			  <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>						  						  
			  <%}else if(pay_gubun.equals("03")){%>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>����� </option>						  
			  <%}else if(pay_gubun.equals("04")){%>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>						  						  
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>������ </option>
                          <option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>ȸ�� </option>
			  <%}else if(pay_gubun.equals("05")){%>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>						  						  
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>������ </option>						  
			  <%}else if(pay_gubun.equals("11")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ȣ </option>						  
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>						  						  
                          <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>�����ȣ </option>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>�����ü </option>						  
			  <%}else if(pay_gubun.equals("12")){%>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>Ź�۾�ü </option>
			  <%}else if(pay_gubun.equals("13")){%>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>��ǰ��ü </option>
			  <%}else if(pay_gubun.equals("17")){%>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>�˻��ü </option>
			  <%}else if(pay_gubun.equals("14")){%>
                          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>�����ü </option>
			  <%}else if(pay_gubun.equals("15")){%>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>						  						  
			  <%}else if(pay_gubun.equals("16")){%>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>						  						  
			  <%}else if(pay_gubun.equals("21")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ȣ </option>						  
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>						  						  
                          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>��������ȣ </option>						  
                          <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>û����� </option>						  						  
			  <%}else if(pay_gubun.equals("22")){%>				  
			  <%}else if(pay_gubun.equals("23")){%>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>		
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>���� </option>						  
			  <%}else if(pay_gubun.equals("24")){%>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>���� </option>						  
			  <%}else if(pay_gubun.equals("25")){%>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>���� </option>						  
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>						  
			  <%}else if(pay_gubun.equals("31")||pay_gubun.equals("37")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>��ȣ </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����ȣ </option>						  
			  <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>						  
			  <%}else if(pay_gubun.equals("33")||pay_gubun.equals("34")||pay_gubun.equals("35")){%>
			  <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>������ȣ </option>						  
			  <%}else if(pay_gubun.equals("51")||pay_gubun.equals("52")||pay_gubun.equals("53")||pay_gubun.equals("55")){%>
			  <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>���� </option>
			  <%}else if(pay_gubun.equals("41")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>�����</option>						  			  
			  <%}else if(pay_gubun.equals("07")||pay_gubun.equals("08")){%>
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>�����ȣ</option>						  			  
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>�������</option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>����</option>
                          <%if(pay_gubun.equals("08")){%>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>��ȣ</option>
                          <%}%>
			  <%}%>
                        </select>
            			&nbsp;&nbsp;&nbsp;
            			<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'></td>		  		  
                    <td class=title width=8%>���Ϻ�</td>
                    <td width=12%>&nbsp;
                    	<%if(pay_gubun.equals("04")){%>
                    	<select name='yet_again'>
                          <option value='N' <%if(yet_again.equals("N")){%>selected<%}%>>�̵�Ϻ�</option>
                          <option value='Y' <%if(yet_again.equals("Y")){%>selected<%}%>>����/����ݺ�</option>
                          <option value='P' <%if(yet_again.equals("P")){%>selected<%}%>>����/����ݺ�</option>
                       </select>    
                    	<%}else{%>
                    	<input type="checkbox" name="yet_again" value="Y" <%if(yet_again.equals("Y")){%>checked<%}%>>
                    	<%}%>
                    	
                    	
                </tr>	  
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2" align="center"><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>			
    <tr>
      <td class=line2></td>
    </tr>	
    <tr>
      <td class=line>
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
		  <tr>
			<td width=30 rowspan="2" class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
			<td width=30 rowspan="2" class='title'>����</td>
			<td width=70 rowspan="2" class='title'>��������</td>	
			<td width=140 rowspan="2" class='title'>����ó</td>
			<td width=210 rowspan="2" class='title'>����</td>				  
			<td width=80 rowspan="2" class='title'>�ݾ�</td>						
			<td width=60 rowspan="2" class='title'>��ݹ��</td>				  			
			<td colspan="2" class='title'>�Ա�����</td>
			<td colspan="2" class='title'>�������</td>				  		  				  
			<td colspan="2" class='title'>ī������</td>
		  </tr>
		  <tr>
		    <td width="60" class='title'>����</td>
	        <td width="110" class='title'>���¹�ȣ</td>
		    <td width=60 class='title'>����</td>
		    <td width=110 class='title'>���¹�ȣ</td>
		    <td width=60 class='title'>ī���</td>
		    <td width=130 class='title'>ī���ȣ</td>
		  </tr>
<%		int count = 0;		
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				if(pay_gubun.equals("35") && String.valueOf(ht.get("P_CD2")).equals("D113HHLR00096")) continue;
				if(pay_gubun.equals("35") && String.valueOf(ht.get("P_CD2")).equals("D115KYPR00116")) continue;
				if(pay_gubun.equals("35") && String.valueOf(ht.get("P_CD2")).equals("S616HHLR00609")) continue;
				if(pay_gubun.equals("35") && String.valueOf(ht.get("P_CD2")).equals("S116KBTL00016")) continue;
				if(pay_gubun.equals("35") && String.valueOf(ht.get("P_CD2")).equals("D115HDHR00240")) continue;
				if(pay_gubun.equals("36") && String.valueOf(ht.get("P_CD2")).equals("B115LE3R00004")) continue;
				
				if(pay_gubun.equals("44") && String.valueOf(ht.get("VEN_NAME")).equals("�츮��(ī���Һ�)")) continue;
				
				count++;
				
				//20210827 �Ե��ĺ�ī��� �ڵ���üó�� -> 20211012 ����ī����(�ڵ������)�� ��� �ĺ�ī�� 44
				if(pay_gubun.equals("44")){ // && String.valueOf(ht.get("VEN_NAME")).equals("�Ե�ī��(����)������")				
					ht.put("P_WAY", "4");
					ht.put("P_ST3", "�ڵ���ü");
					ht.put("BANK_ID", "");
					ht.put("BANK_NM", "");
					ht.put("BANK_NO", "");
					ht.put("BANK_ACC_NM", "");
					ht.put("BANK_CMS_BK", "");
				}
				
				
				t_amt = t_amt + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
				
				//�׿����ڵ� ó��
				if(!String.valueOf(ht.get("VEN_CODE")).equals("") && String.valueOf(ht.get("VEN_NAME")).equals("")){
					Hashtable vendor = neoe_db.getVendorCase(String.valueOf(ht.get("VEN_CODE")));
					ht.put("VEN_NAME", String.valueOf(vendor.get("VEN_NAME")));
				}
				
				//�Աݰ��� ó��
				if(!String.valueOf(ht.get("BANK_NM")).equals("")){
					Hashtable bank = ps_db.getBankCode("", String.valueOf(ht.get("BANK_NM")));
					if(String.valueOf(bank.get("CMS_BK")).equals("null")){
						
					}else{
						ht.put("BANK_CMS_BK", String.valueOf(bank.get("CMS_BK")));
					}
				}
				
				//�Աݰ��� ó��
				if(!String.valueOf(ht.get("BANK_NM")).equals("") && String.valueOf(ht.get("BANK_ID")).equals("")){
					Hashtable bank = ps_db.getCheckd("A03", String.valueOf(ht.get("BANK_NM")));
					if(String.valueOf(bank.get("CHECKD_CODE")).equals("null")){
						
					}else{
						ht.put("BANK_ID", String.valueOf(bank.get("CHECKD_CODE")));
					}
				}
				
				
				//��ݰ��� ó��
				if(!String.valueOf(ht.get("A_BANK_NO")).equals("") && String.valueOf(ht.get("A_BANK_NM")).equals("")){
					Hashtable acc = ps_db.getDepositma(String.valueOf(ht.get("A_BANK_NO")));
					ht.put("A_BANK_ID", String.valueOf(acc.get("BANK_CODE")));
					ht.put("A_BANK_NM", String.valueOf(acc.get("CHECKD_NAME")));
				}
				
				//��ݰ��� ó��
				if(!String.valueOf(ht.get("A_BANK_NM")).equals("")){
					Hashtable bank = ps_db.getBankCode("", String.valueOf(ht.get("A_BANK_NM")));
					if(String.valueOf(bank.get("CMS_BK")).equals("null")){
						
					}else{
						ht.put("A_BANK_CMS_BK", String.valueOf(bank.get("CMS_BK")));
					}
				}
				
				if(String.valueOf(ht.get("EST_DT")).equals("")){
					ht.put("EST_DT", AddUtil.getDate());
				}
				
				if(pay_gubun.equals("44") || pay_gubun.equals("46")){
					ht.put("EST_DT", AddUtil.replace(af_db.getValidDt(String.valueOf(ht.get("EST_DT"))),"-",""));
				}
				
				
				
				%>			  
		  <tr>
			<td align='center'><input type="checkbox" name="ch_cd" value="<%=count-1%>" onclick="javascript:setSamt();" <%if(pay_gubun.equals("04")){%>checked<%}%>></td>
			<td align='center'><%=count%></td>
			<td align='center'><%=ht.get("EST_DT")%></td>
			<td align='center'><%=ht.get("OFF_NM")%><%if(pay_gubun.equals("01")){%><br><font color='#666666'><%=ht.get("OFF_TEL")%></font><%}%></td>
			<td>&nbsp;<span><%=ht.get("P_CONT")%></span>
				<%if(pay_gubun.equals("21")){%><br><font color='#666666'><%=ht.get("ETC_CONT")%></font><%}%>				
				<%if(pay_gubun.equals("08")){%><br><font color='#666666'><%=ht.get("P_CD3")%></font><%}%>			
			</td>			
			<td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>						
			<td align='center'><%=ht.get("P_ST3")%></td>
			<td align='center'><%=ht.get("BANK_NM")%></td>
			<td align='center'><%=ht.get("BANK_NO")%><%if(!String.valueOf(ht.get("BANK_ACC_NM")).equals("")){%><br><font color='#666666'><%=ht.get("BANK_ACC_NM")%></font><%}%></td>
			<td align='center'><%=ht.get("A_BANK_NM")%></td>
			<td align='center'><%=ht.get("A_BANK_NO")%></td>
			<td align='center'><%=ht.get("CARD_NM")%></td>
			<td align='center'><%=ht.get("CARD_NO")%></td>
			<input type='hidden' name='p_st1' 		value='<%=ht.get("P_ST1")%>'>
			<input type='hidden' name='p_st2' 		value='<%=ht.get("P_ST2")%>'>
			<input type='hidden' name='p_st3' 		value='<%=ht.get("P_ST3")%>'>			
			<input type='hidden' name='p_st4' 		value='<%=ht.get("P_ST4")%>'>
			<input type='hidden' name='p_st5' 		value='<%=ht.get("P_ST5")%>'>			
			<input type='hidden' name='p_cd1' 		value='<%=ht.get("P_CD1")%>'>
			<input type='hidden' name='p_cd2' 		value='<%=ht.get("P_CD2")%>'>
			<input type='hidden' name='p_cd3' 		value='<%=ht.get("P_CD3")%>'>
			<input type='hidden' name='p_cd4' 		value='<%=ht.get("P_CD4")%>'>
			<input type='hidden' name='p_cd5' 		value='<%=ht.get("P_CD5")%>'>
			<input type='hidden' name='amt'   		value='<%=ht.get("AMT")%>'>
			<input type='hidden' name='bank_id' 	value='<%=ht.get("BANK_ID")%>'>
			<input type='hidden' name='bank_nm' 	value='<%=ht.get("BANK_NM")%>'>
			<input type='hidden' name='bank_no' 	value='<%=ht.get("BANK_NO")%>'>
			<input type='hidden' name='off_st' 		value='<%=ht.get("OFF_ST")%>'>
			<input type='hidden' name='off_id' 		value='<%=ht.get("OFF_ID")%>'>
			<input type='hidden' name='off_nm' 		value='<%=ht.get("OFF_NM")%>'>
			<input type='hidden' name='p_way' 		value='<%=ht.get("P_WAY")%>'>
			<input type='hidden' name='p_cont' 		value='<%=ht.get("P_CONT")%>'>
			<input type='hidden' name='est_dt' 		value='<%=ht.get("EST_DT")%>'>
			<input type='hidden' name='ven_code' 	value='<%=ht.get("VEN_CODE")%>'>
			<input type='hidden' name='ven_name'	value='<%=ht.get("VEN_NAME")%>'>
			<input type='hidden' name='sub_amt1'	value='<%=ht.get("SUB_AMT1")%>'>
			<input type='hidden' name='sub_amt2'	value='<%=ht.get("SUB_AMT2")%>'>
			<input type='hidden' name='sub_amt3'	value='<%=ht.get("SUB_AMT3")%>'>						
			<input type='hidden' name='sub_amt4'	value='<%=ht.get("SUB_AMT4")%>'>
			<input type='hidden' name='sub_amt5'	value='<%=ht.get("SUB_AMT5")%>'>						
			<input type='hidden' name='card_id' 	value='<%=ht.get("CARD_ID")%>'>
			<input type='hidden' name='card_nm' 	value='<%=ht.get("CARD_NM")%>'>
			<input type='hidden' name='card_no' 	value='<%=ht.get("CARD_NO")%>'>
			<input type='hidden' name='a_bank_id' 	value='<%=ht.get("A_BANK_ID")%>'>
			<input type='hidden' name='a_bank_nm' 	value='<%=ht.get("A_BANK_NM")%>'>
			<input type='hidden' name='a_bank_no' 	value='<%=ht.get("A_BANK_NO")%>'>
			<input type='hidden' name='buy_user_id' value='<%=ht.get("BUY_USER_ID")%>'>			
			<input type='hidden' name='s_idno' 		value='<%=ht.get("S_IDNO")%>'>						
			<input type='hidden' name='acct_code'	value='<%=ht.get("ACCT_CODE")%>'>
			<input type='hidden' name='bank_acc_nm'	value='<%=ht.get("BANK_ACC_NM")%>'>
			<input type='hidden' name='bank_cms_bk'	value='<%=ht.get("BANK_CMS_BK")%>'>
			<input type='hidden' name='a_bank_cms_bk'	value='<%=ht.get("A_BANK_CMS_BK")%>'>		
			<input type='hidden' name='off_tel'		value='<%=ht.get("OFF_TEL")%>'>
			<input type='hidden' name='sub_amt6'	value='<%=ht.get("SUB_AMT6")%>'>				
			
		  </tr>				
<%			}%>
		  <tr>
			<td colspan="5" class='title'>�հ�ݾ�</td>
			<td class='title'><input type='text' name='t_amt' size='15' class='whitenum' value='<%=AddUtil.parseDecimalLong(t_amt)%>'></td>
			<td colspan="7" class='title'>&nbsp;</td>			
		  </tr>				   
		  <tr>
			<td colspan="5" class='title'>���ñݾ�</td>
			<td class='title'><input type='text' name='s_amt' size='15' class='whitenum' value='<%if(pay_gubun.equals("04")){%><%=AddUtil.parseDecimalLong(t_amt)%><%}else{%>0<%}%>'></td>
			<td colspan="7" class='title'>&nbsp;</td>						
		  </tr>				   
        </table>
	  </td>
    </tr>  
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>		
	<%if(pay_gubun.equals("04")){%>
	<tr> 
        <td align="center"> 
            <a href="javascript:save04();"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>
        </td>
    </tr>  	
	<%}else{%>
	<tr> 
        <td align="center"> 
            <a href="javascript:save();"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>
        </td>
    </tr>  	
	<%}%>
    <%}%>	    
  </table>
<input type='hidden' name='size' value='<%=count%>'>  
</form>
<%if(pay_gubun.equals("08")){%>
<script language="JavaScript">
<!--
$("span:contains('�ڵ������ ����ī����� (')").css({color:"#CCCCCC"});
$("span:contains('�ڵ������ �ӽÿ��ຸ���ī����� (')").css({color:"#CCCCCC"});
//-->
</script>
<%}%>
</body>
</html>

