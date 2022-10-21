<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+
				   	"&sh_height="+height+"";
				 
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();			   	
				   	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//검사정산 
function view_jungsan(m1_no, rent_l_cd, gubun)
{
		var fm = document.form1;
		
		window.open("/fms2/ssmoters/car_maint_jungsan_popup.jsp?user_id="+fm.user_id.value+"&auth_rw="+fm.auth_rw.value+"&m1_no="+m1_no+"&rent_l_cd="+rent_l_cd+"&gubun="+gubun, "jungsan", "left=150, top=150, width=450, height=500");
}

//출력
	function select_print(){
		
		var width 	= 1024;		
		var height 	= screen.height;		
		window.open("car_maint_req_list_print.jsp<%=valus%>", "Print", "left=0, top=0, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");				
	}


//결재문서기안
	function select_jung(){
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
		 	alert("정산할 검사를 선택하세요.");
			return;
		}	
		
		if ( document.form1.jung_dt.value == '') {			
			alert('정산일자를  입력하십시오.'); 
			return;
		}
		if(!confirm("결재기안하시겠습니까?"))	return;	
		
		fm.jung_dt.value = document.form1.jung_dt.value;
//		fm.target = "i_no";
		fm.target = "d_content";
		fm.action = "car_maint_conf_a.jsp";
		fm.submit();	
	}		
	
	
	function ChangeDT(arg)
	{
		var theForm = document.form1;
				
		theForm.jung_dt.value = ChangeDate(theForm.jung_dt.value);
		
	}	
	
//-->
</script>
</head>
<body leftmargin=15 rightmargin=0>
<form name='form1' method='post'>

<input type='hidden' name='s_kd' value='<%=s_kd%>'> 
<input type='hidden' name='st_dt' value='<%=st_dt%>'> 
<input type='hidden' name='end_dt' value='<%=end_dt%>'> 
<input type='hidden' name='gubun2' value='<%=gubun2%>'> 
<input type='hidden' name='gubun3' value='<%=gubun3%>'> 
<input type='hidden' name='gubun4' value='<%=gubun4%>'> 
<input type='hidden' name='m1_no' value=''>
<input type='hidden' name='mode' value=''>  
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					 <td align='left'>
				  <%if((auth_rw.equals("4")||auth_rw.equals("6")) && (nm_db.getWorkAuthUser("탁송관리자",user_id)||nm_db.getWorkAuthUser("전산팀",user_id))){%>   
	  					<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정산일자</span>&nbsp;<input type='text' name="jung_dt"  size='11' class='text' onBlur="javascript:ChangeDT('jung_dt')">&nbsp;&nbsp;&nbsp;<a href="javascript:select_jung();">결재문서기안</a>&nbsp;
	 				 <%}%>						
			       <a href="javascript:select_print();"><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a></td>
			  
				</tr>
			</table>
		</td>
	</tr>
	
    <tr>
		<td>
			 <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./car_d1_list_sc_in.jsp?gubun3=<%=gubun3%>&gubun2=<%=gubun2%>&gubun4=<%=gubun4%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>	
</table>
</form>
</body>
</html>