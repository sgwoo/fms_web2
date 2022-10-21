<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.car_register.*"%>
<%@ include file="/acar/cookies.jsp"%>

<%
	//자동차관리 검색 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String s_kd 	= request.getParameter("s_kd")==null?"5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	String actn 	= request.getParameter("actn")==null?"":request.getParameter("actn");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//신청서작성- 지역도 check
function select_car(){
       
       var fm = RegList.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var cnt1=0;
		var idnum="";
		var ck1 = "";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];	
				
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=idnum+ ck.value + ',';
				}
			}
			
			
			if(ck.name == "vid"){
			     if ( i  ==  1) {
				     ck1 = ck.value;	
				//     alert(ck1);			
			     }
			      if ( ck.value != ck1) {
			            cnt1++;
			     }
		          }	     
					
		}	
		
		if(cnt == 0){
		 	alert("출력할 대상을 선택하세요.");
			return;
		}
		
	//	if(cnt 1 > 0){
	//	 	alert("지역을 확인하세요!!!.");
	//		return;
	//	}	
	
		
		var SUMWIN = "";
			
		SUMWIN="doc_car.jsp?ch_cd="+idnum;
		
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
		

}		

function car_print(){
	    
	    var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="car_no_print.jsp?ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>";

		window
				.open(SUMWIN, "ObjectionPrint",
						"left=50, top=50, width=950, height=800, scrollbars=yes, status=yes");

	

	}

	//자동차검사
	function select_doc_car_print() {
	    
	    var fm = RegList.document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum = "";
		for (var i = 0; i < len; i++) {
			var ck = fm.elements[i];
			if (ck.name == "ch_cd") {
				if (ck.checked == true) {
					cnt++;
					idnum = ck.value;
				}
			}
		}
		if (cnt == 0) {
			alert("출력할 자동차 검사 신청서를 선택하세요.");
			return;
		}

		window.open(	'about:blank',
						"CAR_PRINT",
						"left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");

		//		fm.target = "i_no";
		fm.target = "CAR_PRINT";
		fm.action = "doc_car_print_all.jsp";
		fm.submit();
	}
	
	//자동차등록증 출력
	function select_car_doc() {
	    
	    var fm = RegList.document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum = "";
		for (var i = 0; i < len; i++) {
			var ck = fm.elements[i];
			if (ck.name == "ch_cd") {
				if (ck.checked == true) {
					cnt++;
					idnum = ck.value;
				}
			}
		}
		if (cnt == 0) {
			alert("자동차등록증을  출력할 자동차를 선택하세요.");
			return;
		}

		window.open(	'about:blank',
						"CAR_PRINT",
						"left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");

		//		fm.target = "i_no";
		fm.target = "CAR_PRINT";
		fm.action = "doc_car_print_car_no.jsp";
		fm.submit();
	}
	
	//차령만료일 일괄변경
	function modify_all_car_end_dt(){
		
		var fm = RegList.document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var param = "";
		for (var i = 0; i < len; i++) {
			var ck = fm.elements[i];
			if (ck.name == "ch_cd") {
				if (ck.checked == true) {
					param += ck.value + ",";
					cnt ++;
				}
			}
		}
		if (cnt == 0) {
			alert("차령만료일 변경 및 등록증을 등록할 차량을 선택하세요.");
			return;
		}
		
		var url="car_end_dt_modify_all.jsp?param="+param;
		
		window.open(url, "modify_car_end_dt", "left=50, top=50, width=1200, height=800, scrollbars=yes, status=yes");
	}
	
	//차령만료일 일괄변경
	function modify_all_car_req_dt(){
		
		var fm = RegList.document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var param = "";
		for (var i = 0; i < len; i++) {
			var ck = fm.elements[i];
			if (ck.name == "ch_cd") {
				if (ck.checked == true) {
					param += ck.value + ",";
					cnt ++;
				}
			}
		}
		if (cnt == 0) {
			alert("차령만료일 변경 및 등록증을 등록할 차량을 선택하세요.");
			return;
		}
		
		var url="car_req_dt_modify_all.jsp?param="+param;
		
		window.open(url, "modify_car_req_dt", "left=50, top=50, width=500, height=300, scrollbars=yes, status=yes");
	}
//-->
</script>

<style type="text/css">
.button {
	border: 1px solid #7d99ca;
	-webkit-border-radius: 3px;
	-moz-border-radius: 3px;
	border-radius: 4px;
	font-size: 10px;
	font-family: 'Nanum Gothic', sans-serif;
	padding: 5px 5px 4px 5px;
	text-decoration: none;
	display: inline-block;
	text-shadow: -1px -1px 0 rgba(0, 0, 0, 0.3);
	font-weight: bold;
	color: #FFFFFF;
	background-color: #a5b8da;
	background-image: -webkit-gradient(linear, left top, left bottom, from(#a5b8da),
		to(#7089b3));
	background-image: -webkit-linear-gradient(top, #a5b8da, #7089b3);
	background-image: -moz-linear-gradient(top, #a5b8da, #7089b3);
	background-image: -ms-linear-gradient(top, #a5b8da, #7089b3);
	background-image: -o-linear-gradient(top, #a5b8da, #7089b3);
	background-image: linear-gradient(to bottom, #a5b8da, #7089b3);
	filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,
		startColorstr=#a5b8da, endColorstr=#7089b3);
}

.button:hover {
	border: 1px solid #5d7fbc;
	background-color: #819bcb;
	background-image: -webkit-gradient(linear, left top, left bottom, from(#819bcb),
		to(#536f9d));
	background-image: -webkit-linear-gradient(top, #819bcb, #536f9d);
	background-image: -moz-linear-gradient(top, #819bcb, #536f9d);
	background-image: -ms-linear-gradient(top, #819bcb, #536f9d);
	background-image: -o-linear-gradient(top, #819bcb, #536f9d);
	background-image: linear-gradient(to bottom, #819bcb, #536f9d);
	filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,
		startColorstr=#819bcb, endColorstr=#536f9d);
}
</style>
</head>
<body leftmargin="15">
	<form name='form1' method='post'>

		<table border=0 cellspacing=0 cellpadding=0 width=100%>
			<tr>
				<td>
					<table border="0" cellspacing="1" cellpadding="0" width=100%>
						<tr>
							<td align='left'>
								<a href="javascript:select_doc_car_print();" class="button" style="text-decoration: none">자동차검사신청서</a>&nbsp;&nbsp;
								<a href="javascript:select_car_doc();" class="button" style="text-decoration: none">자동차등록증 </a>&nbsp;&nbsp;
								<a href="javascript:modify_all_car_req_dt();" class="button" style="text-decoration: none">처리예정일 등록</a>&nbsp;&nbsp;&nbsp;&nbsp;
								<a href="javascript:modify_all_car_end_dt();" class="button" style="text-decoration: none">차령만료일 일괄변경</a>&nbsp;&nbsp;&nbsp;&nbsp;
								<a href="javascript:select_car();"><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp; 
								<a href="javascript:car_print();"><img src=/acar/images/center/button_num_car.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
							<td align=right>
							</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table border="0" cellspacing="1" cellpadding="0" width=100%>
						<tr>
							<td><iframe
									src="./register_end_sc_in.jsp?height=<%=height%>&sh_height=<%=height%>&actn=<%=actn%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&brid=<%=brid%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&st=<%=st%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&q_sort_nm=<%=q_sort_nm%>&q_sort=<%=q_sort%>"
									name="RegList" width="100%" height="<%=height+10%>"
									cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0"
									border="0" frameborder="0"></iframe></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>