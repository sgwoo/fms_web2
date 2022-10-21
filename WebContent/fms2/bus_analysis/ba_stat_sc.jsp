<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-130;//현황 라인수만큼 제한 아이프레임 사이즈
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
 	//계약서 내용 보기
	function view_cont(m_id, l_cd, use_yn){
		var fm = document.form1;
		fm.rent_mng_id.value = m_id;
		fm.rent_l_cd.value = l_cd;		
		fm.target ='d_content';						
		fm.action = '/fms2/lc_rent/lc_c_frame.jsp';		
		fm.submit();
	}
	
	//내용보기
	function EstiDisp(est_type, est_id, set_code){	
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.set_code.value = set_code;		
		fm.target = 'd_content';
		if(est_type == 'F'){
			if(set_code == '') 	fm.action = '/acar/estimate_mng/esti_mng_u.jsp';
			else  			fm.action = '/acar/estimate_mng/esti_mng_atype_u.jsp';
		}else{
						fm.action = '/acar/estimate_mng/esti_sh_mng_u.jsp';
		}		
		fm.submit();
	}	
	
	//점수일괄등록
	function select_bas(){
		var fm = EstiList.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("등록할 계약/미계약을 선택하세요.");
			return;
		}	
		
		window.open('about:blank', "SCOREREG", "left=0, top=0, width=1050, height=800, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "SCOREREG";
		fm.action = "ba_stat_score_reg.jsp";
		fm.submit();	
	}			
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'>    
  <input type='hidden' name='s_dt'  	value='<%=s_dt%>'>
  <input type='hidden' name='e_dt' 	value='<%=e_dt%>'>			
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/bus_analysis/ba_stat_frame.jsp'>
  <input type='hidden' name='from_page2' value='/fms2/bus_analysis/ba_stat_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='est_id' value=''>
  <input type='hidden' name='set_code' value=''>  
  <input type='hidden' name='c_st' value='etc'>  
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
	    <%if(nm_db.getWorkAuthUser("임원",user_id)||nm_db.getWorkAuthUser("전산팀",user_id)){%>   
	    &nbsp;&nbsp;<a href="javascript:select_bas();" title='일괄등록'><img src=/acar/images/center/button_igdr.gif align=absmiddle border=0></a>	  
	    <%}%>	
	</td>
    </tr>
    <tr>
	<td>
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		    <td colspan=2><iframe src="ba_stat_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="EstiList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
		</tr>								
	    </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>