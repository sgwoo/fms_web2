<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

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
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?height="+height+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+"&gubun7="+gubun7+"&sort="+sort+"&asc="+asc+
				   	"&sh_height="+height+"";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function stat_tax(){
		var fm = document.form1;
		fm.gubun2.value = '5';
		fm.gubun3.value = '2';		
		fm.sort_gubun.value = "3";
		fm.asc.value = "1";
		fm.target = "d_content";
		fm.action = "/acar/con_tax/stat_tax_frame_s.jsp";
		fm.submit();
	}		
	
	//세부내용 보기
	function view_tax(m_id, l_cd, c_id, seq, rent_mon, cls_st, tax_come_dt)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.seq.value = seq;
		fm.rent_mon.value = rent_mon;		
		fm.cls_st.value = cls_st;				
		fm.tax_come_dt.value = tax_come_dt;				
		if(seq == ''){
			fm.action = '/acar/con_tax/tax_scd_i.jsp';
		}else{
			fm.action = '/acar/con_tax/tax_scd_u.jsp';
		}
		fm.target= 'd_content';
		fm.submit();
	}
	
	function excel_tax(st){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "tax_m_sc_in_excel_"+st+".jsp";
		fm.submit();
	}				
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
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
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'>
  <input type='hidden' name='gubun7' 	value='<%=gubun7%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='asc' 		value='<%=asc%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='/fms2/con_tax/tax_m_frame.jsp'>  
  <input type='hidden' name='sort_gubun'value='<%=sort%>'>  
  <input type='hidden' name='m_id' value=''>
  <input type='hidden' name='l_cd' value=''>
  <input type='hidden' name='c_id' value=''>
  <input type='hidden' name='seq' value=''>
  <input type='hidden' name='cls_st' value=''>
  <input type='hidden' name='tax_st' value=''>
  <input type='hidden' name='rent_mon' value=''>
  <input type='hidden' name='dlv_mon' value=''>
  <input type='hidden' name='tax_come_dt' value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
	  </td>
	  <td align='right'>
	    <a href='javascript:stat_tax()'><img src=/acar/images/center/button_tss.gif align=absmiddle border=0></a>
	    
	    &nbsp;&nbsp;
	    <a href='javascript:excel_tax(1)'>[과세물품총판매(반출)명세서]</a>
	    &nbsp;&nbsp;
	    <a href='javascript:excel_tax(2)'>[제품수불상환표]</a>
	    &nbsp;&nbsp;
	    <!--
	    <a href='con_tax_doc_1.htm' target='_blank'>[1]</a>
	    <a href='con_tax_doc_2.htm' target='_blank'>[2]</a>
	    -->
	  </td>	  
	</tr>
	<tr>
	  <td colspan="2">
		<table border="0" cellspacing="0" cellpadding="0" width=100%>
		  <tr>
			<td>
			  <iframe src="tax_m_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
			</td>
		  </tr>
		</table>
	  </td>
	</tr>
  </table>
</form>
</body>
</html>
