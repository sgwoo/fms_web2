<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
	"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&from_page="+from_page+
	"&gubun4="+gubun4+"&gubun5="+gubun5+
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
	//청구처리
	function select_ecar(){
		var fm = inner.document.form1;	
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
		 	alert("처리할 차량을 선택하세요.");
			return;
		}	
		
		fm.ext_est_dt.value = document.form1.ext_est_dt.value;
		
		fm.target = "i_no";
//		fm.target = "d_content";
		fm.action = "ecar_pur_sub_req_a.jsp";
		fm.submit();	
	}	
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='s_kd' value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>
  <input type='hidden' name='andor' value='<%=andor%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/lc_rent/ecar_pur_sub_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>

	        <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("차량대금팀장결재대행",user_id)){%>
	        &nbsp;&nbsp;&nbsp;
	        <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>청구일자</span>&nbsp;
	        <input type='text' name="ext_est_dt" value='<%=AddUtil.getDate()%>' size='11' class='text'>&nbsp;&nbsp;&nbsp;
	        <a href="javascript:select_ecar();">[청구]</a>
	        <%}%>
	        
	      	</td>
	  </tr>
	  <tr>
	      <td>
    		    <table border="0" cellspacing="0" cellpadding="0" width=100%>
    		        <tr>
        			      <td>
        			          <iframe src="ecar_pur_sub_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
        			      </td>
    		        </tr>
    		    </table>
	      </td>
    </tr>
    <tr>
	      <td>* 하이브리드자동차 구매보조금 http://www.hybridbonus.or.kr/ </td>
	  </tr>
</table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
