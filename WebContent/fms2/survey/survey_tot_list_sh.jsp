<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, dates.*"%>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun1 	= request.getParameter("gubun1")==null?"계약":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"신규":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	String dt1 = "";
	String dt2 = "";
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//회차조회
	Vector vt = p_db.getSurvey_All_list(gubun1, gubun2);
	int vt_size = vt.size();
	
	
	Hashtable seu = new Hashtable();
	
	Vector polls = new Vector();
	//구분별	
	if(gubun1.equals("계약")){
		//polls = p_db.getSurveyContPollTot_list( ref_dt1, ref_dt2, gubun3, gubun1, gubun2);
		//polls = p_db.getSurveyCallPollTot_list( ref_dt1, ref_dt2, gubun3, gubun1, gubun2, "CONT_CALL", gubun4);
		polls = p_db.getSurveyCallPollTot_list2( ref_dt1, ref_dt2, gubun3, gubun1, gubun2, "CONT_CALL", gubun4);
		 seu = p_db.getSurvey_Poll_tot(gubun3, "1", "CONT_CALL");
	}else if(gubun1.equals("순회정비")){
		//polls = p_db.getSurveyServicePollTot();
		//polls = p_db.getSurveyCallPollTot_list( ref_dt1, ref_dt2, gubun3, gubun1, gubun2, "SERVICE_CALL", gubun4);
		polls = p_db.getSurveyCallPollTot_list2( ref_dt1, ref_dt2, gubun3, gubun1, gubun2, "SERVICE_CALL", gubun4);
		 seu = p_db.getSurvey_Poll_tot(gubun3, "1", "SERVICE_CALL");
	}else if(gubun1.equals("사고처리")){
		//polls = p_db.getSurveyAccidentPollTot();
		//polls = p_db.getSurveyCallPollTot_list( ref_dt1, ref_dt2, gubun3, gubun1, gubun2, "ACCIDENT_CALL", gubun4);
		polls = p_db.getSurveyCallPollTot_list2( ref_dt1, ref_dt2, gubun3, gubun1, gubun2, "ACCIDENT_CALL", gubun4);
		 seu = p_db.getSurvey_Poll_tot(gubun3, "1", "ACCIDENT_CALL");
	}
	
	int poll_size = polls.size();
	
	//응답자수 카운팅이 리스트 쿼리와 맞지 않아 수정(20181030)
	int tot_cnt = 0;
	for(int i = 0 ; i < poll_size ; i++){
		Hashtable poll = (Hashtable)polls.elementAt(i);
		if(!poll.get("CNT").equals("0")){
			if(poll.get("CONTENT").equals("합계")){
				tot_cnt = AddUtil.parseInt(String.valueOf(poll.get("CNT")));
				break;
			}
		}
	}
	
	//ref_dt1 
	if(ref_dt1.equals("")&&ref_dt2.equals("")){
			Calendar today = Calendar.getInstance();   
		
			int year = today.get(Calendar.YEAR);
		    int month = today.get(Calendar.MONTH)+1;
		    int date = today.get(Calendar.DATE);
		   
			int lastDay = today.getActualMaximum(Calendar.DATE);
			
			String s_mon=Integer.toString(month);
		   if (month < 10) s_mon = "0"+s_mon;
   		   	
			ref_dt1 = year+"-"+s_mon+"-01";
			ref_dt2 = year+"-"+s_mon+"-"+lastDay;
			
			
	}
	
	DecimalFormat df = new DecimalFormat("0.##");
	int m = 0;
//	m = AddUtil.parseInt(String.valueOf(seu.get("TOT"))) * 13;
	m = AddUtil.parseInt(String.valueOf(seu.get("TOT")));
%>
<html>
<head>
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function ChangeDT(arg)
{
	var theForm = document.RentCondSearchForm;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}


//페이지이동
	function move_page(){  
		var fm = document.form1;
		if(fm.gubun1.value==''){							alert('구분을 선택해주세요.');		return false;	}
		else if(fm.gubun2.value==''){							alert('계약타입을 선택해주세요.');	return false;	}
		else if(fm.ref_dt1.value=='' || fm.ref_dt2.value==''){	alert('기간을 입력해주세요.');		return false;	}
		//else if(fm.gubun3.value==''){							alert('회차를 선택해주세요.');		return false;	}
		fm.action = 'survey_tot_list_sh.jsp';
		fm.target = "_self";
		fm.submit();
	}	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
select {
    width: 40%;
    padding: 4px 8px;
    border: 1px solid ;
    border-radius: 4px;
    background-color: #ffff;
	font-size: 1em;
}
</style>
</head>
<body>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<script>
$(function() {
	$("#gubun2").chained("#gubun1");
});
</script>

<script>

function fnPopUp(el, url, pollid, pollseq, aseq, gubun1, gubun2, gubun3, gubun4, ref_dt1, ref_dt2) {
 newwindow=window.open(url+'?poll_id='+pollid+'&poll_seq='+pollseq+'&a_seq='+aseq+'&poll_type='+gubun1+'&poll_st='+gubun2+'&poll_su='+gubun3+'&gubun4='+gubun4+'&ref_dt1='+ref_dt1+'&ref_dt2='+ref_dt2,'survey_pop','height=700,width=900,scrollbars=yes,status=yes');

}


	
		
</script>
<form name='form1' action='survey_tot_list_sh.jsp' target='c_foot' >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 

<div class="navigation">
	<span class=style1>콜센터 ></span><span class=style5>콜 결과 통계현황 </span>
</div>

<div class="search-area">
	<label><i class="fa fa-check-circle"></i> 구분 </label>
		<select id="gubun1" name="gubun1" class="select" style="width:120px;">
			<%-- <option value = "" <%if(gubun1.equals(""))%>selected<%%>> 선택 </option> --%>
			<option value = "계약" <%if(gubun1.equals("계약"))%>selected<%%>>계약</option>
			<option value = "순회정비" <%if(gubun1.equals("순회정비"))%>selected<%%>>순회정비</option>
			<option value = "사고처리" <%if(gubun1.equals("사고처리"))%>selected<%%>>사고처리</option>
		</select>
	<label><i class="fa fa-check-circle"></i> 계약타입 </label>
		<select id="gubun2" name="gubun2" class="select" style="width:120px;" onchange="move_page();">
			<%-- <option value = ""  <%if(gubun2.equals("")){out.print("selected");}%>> 선택 </option> --%>
			<option class="계약" value = "신규"  <%if(gubun2.equals("신규")){out.print("selected");}%>> 신규 </option>
			<option class="계약" value = "대차"  <%if(gubun2.equals("대차")){out.print("selected");}%>> 대차 </option>
			<option class="계약" value = "증차"  <%if(gubun2.equals("증차")){out.print("selected");}%>> 증차 </option>
	<!--		<option class="계약" value = "재리스"  <%if(gubun2.equals("재리스")){out.print("selected");}%>> 재리스 </option> -->
			<option class="계약" value = "월렌트"  <%if(gubun2.equals("월렌트")){out.print("selected");}%>> 월렌트 </option>
			<option class="순회정비" value = "순회정비"  <%if(gubun2.equals("순회정비")){out.print("selected");}%>> 순회정비 </option>
			<option class="사고처리" value = "사고처리"  <%if(gubun2.equals("사고처리")){out.print("selected");}%>> 사고처리 </option>
		</select>
	<label><i class="fa fa-check-circle"></i> 회차 </label>
		<select id="gubun3" name="gubun3" class="select" style="width:250px;">
		<%-- <option value="" <%if(gubun3.equals(""))%>selected<%%>>회차선택</option> --%>
		<%for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			%>
			<%-- <option value="<%=ht.get("POLL_ID")%>" <%if(gubun3.equals(ht.get("POLL_SU")))%>selected<%%>><%=ht.get("POLL_ST")%>:<%=ht.get("POLL_SU")%>(<%=ht.get("START_DT")%>~<%=ht.get("END_DT")%>)</option> --%>
			<option value="<%=ht.get("POLL_ID")%>" <%if(gubun3.equals(ht.get("POLL_ID")))%>selected<%%>><%=ht.get("POLL_ST")%>:<%=ht.get("POLL_SU")%>(<%=ht.get("START_DT")%>~<%=ht.get("END_DT")%>)</option>
		<%}%>
		</select>
		<label><i class="fa fa-check-circle"></i>  
			<select name="gubun4" class="select" style="width:150px;">
				<option value="1" <%if(gubun4.equals("1")){%>selected<%}%>>계약일</option>
				<option value="2" <%if(gubun4.equals("2")){%>selected<%}%>>출고일</option>
				<option value="3" <%if(gubun4.equals("3")){%>selected<%}%>>콜 등록일</option>
			</select>
		</label>
		<input type="text" name="ref_dt1" size="14" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
		~ 
		<input type="text" name="ref_dt2" size="14" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" > 
		
		<input type="button" class="button button4" value="검색" onclick="move_page()"/>
</div>

<table border="0" cellspacing="0" cellpadding="0" width="100%">	
	<tr>
        <%-- <td align="right">콜 응답자 수 : <%if(AddUtil.parseInt(String.valueOf(seu.get("TOT"))) > 0){%><%=seu.get("TOT")%><%}else{%>0<%}%>명</td> --%>
        <td align="right">콜 응답자 수 : <%if(tot_cnt > 0){%><%=tot_cnt%><%}else{%>0<%}%>명</td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border=0 cellspacing=1 width="100%">
                <tr>
					<td class=line >
						<table border=0 cellspacing=1  width="100%">
							<tr>
								<td width=40% class=title height="150">질문</td>
								<td width=50% class=title height="150"></td>				  
								<td width=10% class=title height="150">응답수(%)</td>		  
							</tr>
						</table>
					</td>
				</tr>
    		<%if(poll_size > 0){%>
                <tr>
					<td class=line>
					<%
							for(int i = 0 ; i < poll_size ; i++){
								Hashtable poll = (Hashtable)polls.elementAt(i);
				
							%>
						<table border=0 cellspacing=1 width="100%">
						
							<tr >            
								<td align=<%if(poll.get("CONTENT").equals("합계")){%>center<%}%> width="40%" height="150" 
								<%if(poll.get("A_SEQ").equals("0")||poll.get("A_SEQ").equals("")){%>
									<%if(poll.get("CONTENT").equals("합계")){%>
										class="title"
									<%}else{%>
										style="background-color:lightblue;" 
									<%}%>
								<%}else{%>
								style="background-color:white;"<%}%>
								><%if(poll.get("A_SEQ").equals("0")){%>Q<%=poll.get("POLL_SEQ")%> <%}else{%>&nbsp;&nbsp;&nbsp;<%}%> <%=poll.get("CONTENT")%></td>
								
								<!-- 그래프 표시 -->
								<td align=left width="50%" height="150" 
								<%if(poll.get("A_SEQ").equals("0")||poll.get("A_SEQ").equals("")){%>
									<%if(poll.get("CONTENT").equals("합계")){%>
										class="title"
									<%}else{%>
									style="background-color:lightblue;" 
									<%}%>
								<%}else{%>
								style="background-color:white;"
								<%}%>
								<%-- ><%if(!poll.get("GRAPH").equals("")){%><img src=../../images/result1.gif width=<%=((double)(String.valueOf(poll.get("GRAPH")).length()) / m )*100-10 %>% height="20" style="vertical-align:middle;"> <%}%></td> --%>
								><%if(!poll.get("GRAPH").equals("")&&!poll.get("GRAPH").equals("0")){%><img src=../../images/result1.gif width="<%=df.format((AddUtil.parseInt(String.valueOf(poll.get("CNT")))*100)/tot_cnt)%>%" height="20" style="vertical-align:middle;"> <%}%></td>
								<td align=right width="10%" height="150" 
								<%if(poll.get("A_SEQ").equals("0")||poll.get("A_SEQ").equals("")){%>
									<%if(poll.get("CONTENT").equals("합계")){%>
										class="title" style=" text-align:right;"
									<%}else{%>
									style="background-color:lightblue; text-align:right;" 
									<%}%>
								<%}else{%>
								style="background-color:white; text-align:right;"
								<%}%>
								><%if(!poll.get("CNT").equals("0")){%>
									<%if(!poll.get("CONTENT").equals("합계")){%>
									
									<a href="javascript:fnPopUp(this, 'survey_pop.jsp', '<%=poll.get("POLL_ID")%>','<%=poll.get("POLL_SEQ")%>','<%=poll.get("A_SEQ")%>','<%=gubun1%>','<%=gubun2%>','<%=gubun3%>','<%=gubun4%>','<%=ref_dt1%>','<%=ref_dt2%>')" style="text-decoration:none">
									<%-- <%=poll.get("CNT")%>(<%=df.format((Double.parseDouble(String.valueOf(poll.get("GRAPH"))) / (double)m )*1000) %>%) --%> 
									<%=poll.get("CNT")%>(<%=df.format((AddUtil.parseInt(String.valueOf(poll.get("CNT")))*100)/tot_cnt) %>%)
									</a>
									<%}else{%>
									<%=poll.get("CNT")%>(100%)&nbsp;
									<%}%>
								<%}%></td>
							</tr>
							
						</table>
						<%}%>
					</td>
				</tr>
            <%}else{%>
                <tr> 
                    <td colspan=4 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
            <%}%>
            </table>
        </td>
    </tr>
</table>
</form>

</body>
</html>
