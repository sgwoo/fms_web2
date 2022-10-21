<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");

	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	if(nm_db.getWorkAuthUser("아마존카이외",user_id)){
		s_kd = "8";
	}
	
	String  gubun4  =Integer.toString(AddUtil.getDate2(1));
		
	String dept_id = login.getDept_id(ck_acar_id);
			
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+
				   	"&sh_height="+height+"";
    
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<body leftmargin=15 rightmargin=0>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='gubun4'  value='<%=gubun4%>'>       
   
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/off/parts/parts_mng_s_frame.jsp'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
		<td>
			 <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td colspan=2><iframe src="parts_mng_s_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
				</tr>							
	
			</table>
		</td>
  </tr>    
    <tr>
        <td>    
		<table width="1000" border="0" cellspacing="0" cellpadding="0">
		    <tr>
		        <td class=line2></td>
		    </tr>
		    <tr> 
		 	  <td class="line">
			    <table border="0" cellspacing="1" cellpadding="0" width='1000'>
			           <td width=360 class=title style='height:30'>부품구입업무 비용 지원 금액(공급가)</td>
		                    <td width=105   align="right">&nbsp;<input type=text name="m_sum" size=13 class=whitenum  readonly ></td>
		                    <td width=105   align="right">&nbsp;<input type=text name="o_sum"   size=13 class=whitenum  readonly ></td>
		                    <td width=110 align="right">&nbsp;<input type=text name="t_sum"  " size=13 class=whitenum  readonly ></td>   
		                    <td width=105   align="right">&nbsp;<input type=text name="m_l__sum" size=13 class=whitenum  readonly ></td>
		                    <td width=105   align="right">&nbsp;<input type=text name="o_l_sum"   size=13 class=whitenum  readonly ></td>
		                    <td width=110 align="right">&nbsp;<input type=text name="t_l_sum"  " size=13 class=whitenum  readonly ></td>   
		            </table>
		        </td>
		    </tr>                  
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
