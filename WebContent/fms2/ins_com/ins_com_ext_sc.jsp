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
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-130;//현황 라인수만큼 제한 아이프레임 사이즈
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";

%>
<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.3.0/jquery.form.js"></script> 
<script>
<!--
	var checkBtn= false;
	var chkFlag = "N";
	//보기
	function view_ins_com(reg_code, seq){
		window.open("ins_com_u.jsp<%=valus%>&code="+reg_code+"&seq="+seq, "VIEW_INS_COM", "left=100, top=100, width=700, height=900, scrollbars=yes");
	}
	
	function help_ins_com(){
		window.open("ins_com_chk_help.jsp", "VIEW_HELP_INS_COM", "left=300, top=100, width=700, height=700, scrollbars=yes");
	}		
	//요청
	function select_ins_com(st){
		if(checkBtn){
			alert("현재 프로시저 작동 중 입니다. 버튼은 한번만 클릭해주세요.");
			return ;
		}
		
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var cnt2=0;
		var idnum="";
		var act_ment="";
		var chk_value="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					if(st == '1'){
						var ch_split = idnum.split("/");
						if(document.form1.size.value == 1){
							chk_value = fm.chk_cont.value;
						}else{
							chk_value = fm.chk_cont[ch_split[2]].value;
					 	}
						if(chk_value == ''){
							cnt2 = 1;
							ck.checked == false;
						}else{
							cnt++;
						}
					}else{
						cnt++;
					}
				}
			}
		}	
		if(cnt2 == 1){
			alert('미점검건이 있습니다.');
			return;
		}	
		if(cnt == 0){
		 	alert("차량을 선택하세요.");
			return;
		}	
		
		fm.size.value = document.form1.size.value;
		
		act_ment="요청";
		fm.action = "ins_com_req_a.jsp";
		
		if(st == '2'){
			act_ment="점검";
			fm.action = "ins_com_chk_a.jsp";
			chkFlag = "Y";
		}
		if(st == '3'){
			act_ment="취소";
			fm.action = "ins_com_cancel_a.jsp";
		}
		if(st == '4'){
			var user_id = "<%=user_id%>";
			
			<%if(!nm_db.getWorkAuthUser("보험업무",user_id)){%>   
				alert("반영 권한이 없습니다. 권한 확인 바랍니다.");
				return;
		   <%}%>
			
			act_ment="반영";
			fm.action = "ins_com_act_ext_a.jsp";
		}
		if(st == '5'){
			
			act_ment="반려";
			fm.action = "ins_com_req_a.jsp";
		}
		
		if(confirm(act_ment+' 하시겠습니까?')){
			if(st == '4') {checkBtn = true;}
			fm.target = "i_no";
			//fm.target = "_blank";
			fm.submit();
			
			
		}
	}
	
	function allChange() {
		
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		
		if(chkFlag == "N") {
			alert("점검을 먼저 진행해주세요.");
			return;
		}
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];	
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
				}
			}
		}
		//chk_cont
		if(cnt == 0) {
			alert("정상 처리할 항목을 선택하세요.");
			return;
		} else {
			fm.action = "ins_com_change_a.jsp";
			fm.target = "i_no";
			fm.submit();
		}
		
	}
	
	function excel_download(){
		var period = "<%=gubun3%>";
		var startDate = "";
		var endDate = "";
		if(period == '당일') period="today";
		else if(period == '전일') period="prevday";
		else if(period == '당해') period="year";
		else if(period == '당월') period="month";
		else if(period == '전월') period="premonth";
		else if(period == '기간'){ 
			period = "period";
			startDate= "<%=st_dt%>";	
			endDate= "<%=end_dt%>";	
			
			var date = new Date();
            date.setFullYear(date.getFullYear(),0,1);
            
			if(!startDate) startDate =  getFormatDate(date);
			if(!endDate) endDate =  getFormatDate(new Date());

		}
		var gubun = "<%=gubun2%>";
		var search_text = "<%=t_wd%>";
		var search_gubun = "";
		if(search_text)search_gubun="<%=s_kd%>";
		
		if(search_gubun == '1') search_gubun = "carnum";
		else if(search_gubun == '2') search_gubun = "vinum";
		else if(search_gubun == '3') search_gubun = "carnm";
		else if(search_gubun == '4') search_gubun = "usernm";
		else if(search_gubun == '5') search_gubun = "startdt";
	
		var user_id = "<%=gubun1%>";
		if(user_id == "0008") user_id="000300";
		if(user_id == "0007") user_id="000310";
		
		location.href = "https://fms.amazoncar.co.kr/off_web/ins_com/insuUpdExcel3.do?"+
				"page=1&rows=1000&sidx=req_dt&sord=asc"+
				"&period="+period+"&startDate="+startDate+"&endDate="+endDate+"&gubun="+ encodeURI(gubun,"UTF-8")+"&search_text="+encodeURI(search_text,"UTF-8")+"&search_gubun="+search_gubun+"&userId="+user_id+" ";
		
// 		location.href = "http://localhost:8077/off_web/ins_com/insuUpdExcel3.do?"+
// 				"page=1&rows=1000&sidx=req_dt&sord=asc"+
// 				"&period="+period+"&startDate="+startDate+"&endDate="+endDate+"&gubun="+ encodeURI(gubun,"UTF-8")+"&search_text="+encodeURI(search_text,"UTF-8")+"&search_gubun="+search_gubun+"&userId="+user_id+" ";
		
		if(user_id == "0038"){ 
			user_id="000290";
			location.href = "https://fms.amazoncar.co.kr/off_web/ins_com/insuUpdExcel.do?"+
			"page=1&rows=1000&sidx=req_dt&sord=asc"+
			"&period="+period+"&startDate="+startDate+"&endDate="+endDate+"&gubun="+ encodeURI(gubun,"UTF-8")+"&search_text="+encodeURI(search_text,"UTF-8")+"&search_gubun="+search_gubun+"&userId="+user_id+" ";
			
		}
	}
	
	function getFormatDate(date){
		var year = date.getFullYear();                 
		var month = (1 + date.getMonth());             
		month = month >= 10 ? month : '0' + month;     
		var day = date.getDate();                      
		day = day >= 10 ? day : '0' + day;             
		return  year + '' + month + '' + day;
	}
	
	function excel_upload(){
		$('#excel-upload-file').trigger('click');
	}
	
	function fileChange(){
		 $('#excel-upload-button2').trigger('click');
	}
	
    function submitBtn(){
        if(confirm("해당 엑셀을 적용하시겠습니까?")) {
			$('#excel-upload').ajaxForm({
				dataType: "json",
				beforeSubmit: function(data, form, option) {
					return true;
				},
				success: function(data) {
				   alert('파일업로드 성공했습니다');
				   var fm = document.form1;	
				    fm.submit();
				},
				error: function(e) {
				    if(!e.responseText) alert('파일업로드 성공했습니다');
				    else alert('파일업로드 실패했습니다');
				    var fm = document.form1;	
				    fm.submit();
				}
          	});
        } else {
            return false;
        }
    } 
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/ins_com/ins_com_ext_frame.jsp'>
  <input type='hidden' name='reg_code' value=''>
  <input type='hidden' name='seq' value=''>
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='' size='4' class=whitenum> 건</span>
	  <%if(nm_db.getWorkAuthUser("전산팀",user_id)||nm_db.getWorkAuthUser("보험업무",user_id)){%>   
	  <%	if(gubun2.equals("등록")){%>
	  &nbsp;&nbsp;&nbsp;&nbsp;
	  <input type="button" class="button btn-submit" value="요청하기" onclick="select_ins_com(1)"/>
	  &nbsp;&nbsp;&nbsp;&nbsp;
	  <input type="button" class="button btn-submit" value="점검하기" onclick="select_ins_com(2)"/>
	  &nbsp;
	  <input type="button" class="button" value="점검?" onclick="help_ins_com()"/>
	  &nbsp;&nbsp;&nbsp;
	  <input type="button" class="button btn-submit" value="취소하기" onclick="select_ins_com(3)"/>
	  &nbsp;
	  <input type="button" class="button btn-submit" value="일괄 정상 처리" onclick="allChange()"/>
	  &nbsp;
	  <%} else if(gubun2.equals("요청")){%>
	   <%if(gubun1.equals("0008")||gubun1.equals("0007")||gubun1.equals("0038") ){ %> 
	  &nbsp;&nbsp;&nbsp;&nbsp;
	  <input type="button" class="button btn-submit" value="엑셀다운로드" onclick="excel_download()"/>
	  &nbsp;&nbsp;
	  <input type="button" class="button" value="엑셀업로드" onclick="excel_upload()" type="submit"/>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  <%} %>
	   <input type="button" class="button btn-submit" value="취소하기" onclick="select_ins_com(3)"/>
	  <%	}else if(gubun2.equals("확인")){%>
	  <input type="button" class="button btn-submit" value="보험에 결과 반영하기" onclick="select_ins_com(4);" />
	  &nbsp;&nbsp;&nbsp;
	   <input type="button" class="button btn-submit" value="반려하기" onclick="select_ins_com(5)"/>
	   &nbsp;&nbsp;&nbsp;
	  <input type="button" class="button btn-submit" value="취소하기" onclick="select_ins_com(3)"/>
	  <%	}%>
	  <%}%>	  
	  </td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="ins_com_ext_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<%-- 엑셀 전송용 폼 --%>
<%if(gubun1.equals("0038")){%>
 	<form name='form2' id="excel-upload" action="https://fms.amazoncar.co.kr/off_web/ins_com/insuUpdExcel.do" method="post" enctype="multipart/form-data"> 
	    <input type="file" id="excel-upload-file" name="file" onchange="fileChange()">
	    <input id="excel-upload-button2" type="submit" value="업로드" onClick="submitBtn()" />
	</form> 
<%}else{%>
	 <form name='form2' id="excel-upload" action="https://fms.amazoncar.co.kr/off_web/ins_com/insuUpdExcel3.do" method="post" enctype="multipart/form-data"> 
	    <input type="file" id="excel-upload-file" name="file" onchange="fileChange()">
	    <input id="excel-upload-button2" type="submit" value="업로드" onClick="submitBtn()" />
	</form> 
<!-- 	 <form name='form2' id="excel-upload" action="http://localhost:8088/off_web/ins_com/insuUpdExcel3.do" method="post" enctype="multipart/form-data">  -->
<!-- 	    <input type="file" id="excel-upload-file" name="file" onchange="fileChange()"> -->
<!-- 	    <input id="excel-upload-button2" type="submit" value="업로드" onClick="submitBtn()" /> -->
<!-- 	</form>  -->
<%}%> 
	

</body>
</html>
