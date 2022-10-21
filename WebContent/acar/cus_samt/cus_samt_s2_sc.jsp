<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cus0401.*, acar.cus_samt.*" %>
<jsp:useBean id="cnd" scope="page" class="acar.common.ConditionBean"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "04", "04");	
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	
	String st_dt = s_year + s_mon + "01";
	String end_dt = s_year + s_mon + "31";
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");
	String first = request.getParameter("first")==null?"":request.getParameter("first");
	
	if(t_wd.equals("") && st_dt.equals("") && end_dt.equals("")){
	  st_dt = AddUtil.getDate();
	  end_dt = AddUtil.getDate();
	}
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 4; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();

	String ven_code = "";	
	ven_code = cs_db.getServOffVenCode(acct);

	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>

<script language="JavaScript">
<!--

//����Ʈ ���� ��ȯ - 
function pop_excel1(s_year, s_mon, s_day, acct){
	var fm = document.form1;
	
	var i_fm = document.inner.form1;
	
	if (s_day == '' ) {
	  	alert("������ȯ�� �� �� �����ϴ� !!!, ��꼭�������� �����ϼ���!!!");
		return;
	}
	
		
	//����Ÿ Ȯ�� 
	if (fm.vt_size.value == '' ) {
	  	alert("������ȯ�� �� �� �����ϴ� !!!, ����Ÿ�� �����ϴ�.!!!!");
		return;
	}
	
	//����ȸ���� �־���� -2022-02-24 
	var scd_cnt = 0;
	var scd_size 	= toInt(fm.vt_size.value);	
	
	if ( scd_size < 2) {
		 if (i_fm.set_dt.value == '') {
	    	 scd_cnt=scd_cnt + 1;
	     }	
	} else {	 
		for(var i = 0 ; i < scd_size ; i ++){	
		
		     if (i_fm.set_dt[i].value == '') {
		    	 scd_cnt=scd_cnt + 1;
		     }		
		}
	}
	
	if ( scd_cnt > 0 ) {
		 alert( "������ �ȵǾ� �ִ� ���Դϴ�. Ȯ���ϼ���.!!!");
		 return;
	}	
	
	fm.target = "_blank";
	
	fm.action = "popup_excel_multi_service1.jsp?s_year=" + s_year+ "&s_mon=" + s_mon+ "&s_day=" + s_day+ "&acct=" + acct;
	fm.submit();
}	


//����Ʈ ���� ��ȯ - 
function pop_excel(s_year, s_mon, s_day, acct){
	var fm = document.form1;
	
	var i_fm = document.inner.form1;
	
	if (s_day == '' ) {
	  	alert("������ȯ�� �� �� �����ϴ� !!!, ��꼭�������� �����ϼ���!!!");
		return;
	}
	
	//����Ÿ Ȯ�� 
	if (fm.vt_size.value == '' ) {
	  	alert("������ȯ�� �� �� �����ϴ� !!!, ����Ÿ�� �����ϴ�.!!!!");
		return;
	}
	
	//����ȸ���� �־���� -2022-02-24 
	var scd_cnt = 0;
	var scd_size 	= toInt(fm.vt_size.value);	
	
	if ( scd_size < 2) {
		 if (i_fm.set_dt.value == '') {
	    	 scd_cnt=scd_cnt + 1;
	     }		
	} else {	 
		for(var i = 0 ; i < scd_size ; i ++){	
		
		     if (i_fm.set_dt[i].value == '') {
		    	 scd_cnt=scd_cnt + 1;
		     }		
		}
	}
	
	if ( scd_cnt > 0 ) {
		 alert( "������ �ȵǾ� �ִ� ���Դϴ�. Ȯ���ϼ���.!!!");
		 return;
	}	
	
	fm.target = "_blank";
	
	fm.action = "popup_excel_multi_service.jsp?s_year=" + s_year+ "&s_mon=" + s_mon+ "&s_day=" + s_day+ "&acct=" + acct;
	fm.submit();
}	

function make_magam(s_yy, s_mm, s_dd, acct){
	//	var fm = document.form1;
		var fm = document.inner.form1;
		
		if (s_dd == '' ) {
		  	alert("������  �� �� �����ϴ� !!!, ��꼭�������� �����ϼ���!!!");
			return;
		}
		
		//����Ÿ Ȯ�� 
		if (fm.vt_size.value == '' ) {
		  	alert("������ ��  �� �����ϴ� !!!, ����Ÿ�� �����ϴ�.!!!!");
			return;
		}
		
		var acct_dt = s_yy+s_mm+s_dd;
		
		if(!confirm('�ش� ����Ÿ�� �����Ͻðڽ��ϱ�?')){	return;	}
			
		fm.target = "i_no";
	//	fm.action = "cus_samt_s2_magam_a.jsp?acct_dt="+acct_dt+"&acct="+acct;
	
	    if (fm.vt_size.value == '1' ) {
			fm.action = "cus_samt_s2_magam_a1.jsp";
			fm.submit();	
	    } else { 
			fm.action = "cus_samt_s2_magam_a.jsp";
			fm.submit();
	    }
}	


//��ǥ����
function make_autodocu(s_yy, s_mm, s_dd, acct){
	
	var fm = document.form1;
	
	var i_fm = document.inner.form1;
	
	var acct_dt = s_yy+s_mm+s_dd;
		
	if (s_dd == '' ) {
	  	alert("��ǥ�� ������ �� �����ϴ� !!!, ��꼭�������� �����ϼ���!!!");
		return;
	}
	//����Ÿ Ȯ�� 
	if (fm.vt_size.value == '' ) {
	  	alert("��ǥ�� ������ �� �����ϴ� !!!, ����Ÿ�� �����ϴ�.!!!!");
		return;
	}
	
	//����ȸ���� �־���� -2022-02-24 
	var scd_cnt = 0;
	var scd_size 	= toInt(fm.vt_size.value);	
	
	if ( scd_size < 2) {
		 if (i_fm.set_dt.value == '') {
	    	 scd_cnt=scd_cnt + 1;
	     }		
	} else {	 
		for(var i = 0 ; i < scd_size ; i ++){	
		
		     if (i_fm.set_dt[i].value == '') {
		    	 scd_cnt=scd_cnt + 1;
		     }		
		}
	}
	
	if ( scd_cnt > 0 ) {
		 alert( "������ �ȵǾ� �ִ� ���Դϴ�. Ȯ���ϼ���.!!!");
		 return;
	}	
	
	if(confirm('��ǥ���� �Ͻðڽ��ϱ�?')){
		fm.target = "i_no";
		fm.action = "cus_samt_s2_autodocu_a.jsp?acct_dt="+acct_dt+"&acct="+acct;
		fm.submit();
	}				 	
}

//����� ���� Ȯ�� ó�� 
function cal_set_dt(){
	
	var fm = document.inner.form1;
	
	var scd_size 	= toInt(fm.vt_size.value);	
		
	//����Ÿ Ȯ�� 
	if (scd_size == 0 ) {
	  	alert("����Ÿ ���� Ȯ���� �� �� �����ϴ�!!!, ����Ÿ�� �����ϴ�.!!!!");
		return;
	}
	
	var scd_cnt = 0;
	
	
	if ( scd_size < 2) {
		 if (fm.r_set_dt.value != '') {
	    	 scd_cnt=scd_cnt + 1;
	     }		
	} else {
	
		for(var i = 0 ; i < scd_size ; i ++){	
		
		     if (fm.r_set_dt[i].value != '') {
		    	 scd_cnt=scd_cnt + 1;
		     }		
		}
	}
	
//    scd_cnt = 0;
    
	if ( scd_cnt > 0 ) {
		 alert( "������ �Ǿ��ִ� ���Դϴ�.����Ÿ ���� �� �� �����ϴ�.!!!");
		 return;
	} else {
		if ( scd_size < 2) {
			fm.set_dt.value = fm.cal_set_dt.value; //������ ��갪		
			fm.jung_st.value = fm.cal_jung_st.value; //����ȸ�� ��갪		
		} else {
			for(var i = 0 ; i < scd_size ; i ++){	
						
				fm.set_dt[i].value = fm.cal_set_dt[i].value; //������ ��갪		
				fm.jung_st[i].value = fm.cal_jung_st[i].value; //����ȸ�� ��갪		
			}
		}
		
		alert('����Ÿ�� �����߽��ϴ�.');
	}
}

//-->
</script>
</head>

<body>
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='s_year' value='<%=s_year%>'>
  <input type='hidden' name='s_mon' value='<%=s_mon%>'>
  <input type='hidden' name='s_day' value='<%=s_day%>'>
  <input type='hidden' name='sort' value='<%=sort%>'>
  <input type='hidden' name='asc' value='<%=asc%>'>
  <input type='hidden' name='j_g_amt' value=>
  <input type='hidden' name='j_b_amt' value=>
  <input type='hidden' name='j_g_dc_amt' value=>
  <input type='hidden' name='j_ext_amt' value=>
  <input type='hidden' name='j_dc_amt' value=>
  <input type='hidden' name='acct' value='<%=acct%>'>
  <input type='hidden' name='ven_code' value='<%=ven_code%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>   
  <input type='hidden' name='vt_size' >
   <input type='hidden' name='jung_st' >
   
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    
	<td align='right' width=100%>&nbsp;&nbsp;* excel ��½� �μ�̸����� ���� 75%,  �������������� ����,������ ���� 0.4 &nbsp;
	<!-- ������ �ȵ� ��츸 ����Ÿ ���� ����  -->	
	&nbsp;<a href="javascript:pop_excel1('<%=s_year%>', '<%=s_mon%>', '<%=s_day%>', '<%=acct%>');" >[��꼭������]</a>
	&nbsp;<a href="javascript:pop_excel('<%=s_year%>', '<%=s_mon%>', '<%=s_day%>', '<%=acct%>');"><img src=../images/center/button_excel.gif align=absmiddle border=0></a>
	<%if ( auth_rw.equals("4") || auth_rw.equals("6") ) {%>	
	&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:cal_set_dt();">[����Ÿ����Ȯ��]</a>	
<!-- 	&nbsp;<a href="javascript:make_magam('<%=s_year%>', '<%=s_mon%>', '<%=s_day%>', '<%=acct%>');"><img src=../images/center/button_mg.gif align=absmiddle border=0></a>	 -->
	&nbsp;<a href="javascript:make_autodocu('<%=s_year%>', '<%=s_mon%>', '<%=s_day%>', '<%=acct%>');"><img src=../images/center/button_jpss.gif align=absmiddle border=0></a>
     <% } %>
          
	</td>
  </tr>	
    
  <tr> 
    <td align='center'>
    <iframe src="./cus_samt_s2_sc_in.jsp?first=<%=first%>&acct=<%=acct%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_day=<%=s_day%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&height=<%=height%>" name="inner" width="100%" height="<%=height +35 %>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
  </tr>
  <tr> 
    <td>&nbsp;<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe></td>
  </tr>

</table>
</form>
</body>
</html>
