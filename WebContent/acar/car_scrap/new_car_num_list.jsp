<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 				= 	request.getParameter("auth_rw")				==null?"":request.getParameter("auth_rw");
	String sch_car_ext 		= 	request.getParameter("sch_car_ext")		==null?"":request.getParameter("sch_car_ext");
	String sch_reg_dt_str 	= 	request.getParameter("sch_reg_dt_str")	==null?"":request.getParameter("sch_reg_dt_str");
	String sch_reg_dt_end 	= 	request.getParameter("sch_reg_dt_end")	==null?"":request.getParameter("sch_reg_dt_end");
	String sch_end_dt_str 	= 	request.getParameter("sch_end_dt_str")	==null?"":request.getParameter("sch_end_dt_str");
	String sch_end_dt_end 	= 	request.getParameter("sch_end_dt_end")	==null?"":request.getParameter("sch_end_dt_end");
	String car_no_leng 		= 	request.getParameter("car_no_leng")		==null?"":request.getParameter("car_no_leng");

	Vector lists = sc_db.getNewCarNumList2(sch_car_ext, sch_reg_dt_str, sch_reg_dt_end, sch_end_dt_str, sch_end_dt_end, car_no_leng);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
});
function newCarNumReg(){
	var car_num_area = $("#car_num_area").val();
	var car_num_ko = $("#car_num_ko").val();
	var car_num_first = $("#car_num_first").val();
	var car_num_last = $("#car_num_last").val();
	var reg_dt = $("#reg_dt").val();
	var end_dt = $("#end_dt").val();
	
	if(car_num_area == ""){
		alert("지역구분 숫자를 입력하세요.");
		$("#car_num_area").focus();
	}else if(car_num_ko == ""){
		alert("자동차번호의 한글을 입력하세요.");
		$("#car_num_ko").focus();
	}else if(car_num_first == ""){
		alert("처음번호를 입력하세요.");
		$("#car_num_first").focus();
	}else if(car_num_last == ""){
		alert("마지막번호를 입력하세요.");
		$("#car_num_last").focus();
	}else if(reg_dt == ""){
		alert("수령일자를 입력하세요.");
		$("#reg_dt").focus();
	}else{
		var fm = document.form1;
		if(end_dt == null || end_dt == ""){
			var reg_dt_year = reg_dt.substring(0,4);
			var reg_dt_month = reg_dt.substring(4,6);
			var reg_dt_date = reg_dt.substring(6,8);
			var end_date = new Date(reg_dt_year, reg_dt_month, reg_dt_date-1); // 한달후 날짜
			end_dt = dateToYYYYMMDD(end_date);
			$("#end_dt").val(end_dt);
		}
		if(confirm('등록 하시겠습니까?')){
			var fn = "reg_new_car_no";
			fm.action = 'new_car_num_list_a.jsp?fn='+fn;
			fm.target = 'i_no';
			fm.submit();
		}
	}	
}

//배정구분 일괄저장 버튼
function regAllCarNoStat(){
	var fm = document.form1;
	if(confirm('현재 배정구분 상태 그대로 일괄 저장 됩니다.\n\n현재 페이지에서는 배정구분이 신규 상태인 번호만 표시됩니다.\n\n저장 하시겠습니까?')){
		var fn = "save_car_no_stat";		
		fm.action='new_car_num_list_a.jsp?fn='+fn;		
		fm.target='i_no';			
		fm.submit();
	}
}

//선택한 번호 삭제
function delCarNo(){
	
	var fm = document.form1;
	var len=fm.elements.length;	
	var cnt=0;
	var param="";
	for(var i=0 ; i<len ; i++){
		var ck=fm.elements[i];		
		if(ck.name == "ch_cd"){		
			if(ck.checked == true){
				param += ck.value + ",";
				cnt ++;
			}
		}
	}
	if(cnt == 0){
	 	alert("삭제할 차량번호를 선택하세요.");
		return;
	}else{
		if(confirm("선택한 번호들을 정말 삭제하시겠습니까?")){
			var fn = "delete_car_no";
			fm.action='new_car_num_list_a.jsp?fn='+fn+'&param='+param;		
			fm.target='i_no';			
			fm.submit();
		}
	}
}

//검색기능
function search(){
	var fm = document.form1;
	fm.target = "_self";
	fm.submit();
}

function dateToYYYYMMDD(date){
    function pad(num) {
        num = num + '';
        return num.length < 2 ? '0' + num : num;
    }
    return date.getFullYear() + '' + pad(date.getMonth()+1) + '' + pad(date.getDate());
}

function ChangeDT(arg){
	var fm = document.form1;
	if(arg=="sch_reg_dt_str"){		fm.sch_reg_dt_str.value = ChangeDate(fm.sch_reg_dt_str.value);	}
	else if(arg=="sch_reg_dt_end"){	fm.sch_reg_dt_end.value = ChangeDate(fm.sch_reg_dt_end.value);	}
	else if(arg=="sch_end_dt_str"){	fm.sch_end_dt_str.value = ChangeDate(fm.sch_end_dt_str.value);	}
	else if(arg=="sch_end_dt_end"){	fm.sch_end_dt_end.value = ChangeDate(fm.sch_end_dt_end.value);	}
}

//계약-번호간 매핑 제거(2018.01.31)
function dropCont(car_no){
	if(confirm("자동차번호와 계약의 연동을 해지하시겠습니까?")){
		var fm = document.form1;
 		var fn = "drop_cont";
		fm.action='new_car_num_list_a.jsp?fn='+fn+'&param='+car_no;		
	 	fm.target='i_no';			
		fm.submit();
 	}
}

//차량번호 킵 - 비고
function pop_keep_etc(car_no, seq){
	var fm = document.form1;	
	window.open("new_car_num_pop.jsp?car_no="+car_no+"&seq="+seq, "KEEP_ETC", "left=10, top=10, width=600, height=200, scrollbars=yes, status=yes, resizable=yes");
}

//차량번호 구형/해제 일괄저장 버튼 -> 신형에서 구형으로 변경. 20210910
function regAllCarNoNew() {			
	var fm = document.form1;
	var len = fm.elements.length;
	var cnt = 0;
	var param = "";	
	for (var i = 0; i < len; i++) {
		var ck=fm.elements[i];
		if (ck.name == "ch_cd") {
			if (ck.checked == true) {
				param += ck.value + ",";
				cnt ++;
			}
		}
	}
	if (cnt == 0) {
	 	alert("구형/해제 할 차량번호를 선택하세요.");
		return;
	} else {
		if (confirm("선택한 번호를 구형/해제 하시겠습니까?")) {
			var fn = "save_car_no_new";
			fm.action='new_car_num_list_a.jsp?fn='+fn+'&param='+param;
			fm.target='i_no';
			fm.submit();
		}
	}
}

//차량번호 킵/해제 일괄저장 버튼
function regAllCarNoKeep(){			
	var fm = document.form1;
	var len=fm.elements.length;	
	var cnt=0;
	var param="";
	for(var i=0 ; i<len ; i++){
		var ck=fm.elements[i];		
		if(ck.name == "ch_cd"){		
			if(ck.checked == true){
				param += ck.value + ",";
				cnt ++;
			}
		}
	}
	if(cnt == 0){
	 	alert("킵/해제 할 차량번호를 선택하세요.");
		return;
	}else{
		if(confirm("선택한 번호를 킵/해제 하시겠습니까?")){
			var fn = "save_car_no_keep";
			fm.action='new_car_num_list_a.jsp?fn='+fn+'&param='+param;		
			fm.target='i_no';			
			fm.submit();
		}
	}
}

</script>
</head>
<body>
<div class="navigation" style="margin-bottom:0px !important">
	<span class="style1">차량관리 > 차량등록관리 > </span><span class="style5">신규 자동차번호 관리</span>
</div>
<div style="height: 30px;"></div>
<div style="margin-bottom: 15px;"><label><i class="fa fa-check-circle"></i> 신규자동차번호 사용등록</label></div>
<form name="form1" method="post">
<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
			<table class='line' border=0 cellspacing=1 cellpadding=0 width=100% style="text-align: center;">
				<colgroup>
					<col width="3%">
					<!-- <col width="5%"> -->
					<col width="8%">
					<col width="8%">
					<col width="8%">
					<col width="8%">
					<col width="8%">
					<col width="12%">
					<col width="12%">
					<col width="8%">
				</colgroup>
				<tr>
					<td class=title rowspan="3">구분</td>
					<!-- <td class=title rowspan="3">직접등록</td> -->
					<td class=title colspan="8">자동등록</td>
				</tr>
				<tr>
					<td class=title rowspan="2">발행관청</td>
					<td class=title rowspan="2">지역구분</td>
					<td class=title rowspan="2">한글</td>
					<td class=title colspan="2">연번</td>
					<td class=title rowspan="2">수령일자</td>
					<td class=title rowspan="2">만기일자</td>
					<td class=title rowspan="3"><input  type="button" class="button" value="등록실행" onclick="javascript:newCarNumReg();"></td>
				</tr>
				<tr>
					<td class=title >처음번호</td>
					<td class=title >마지막 번호</td>
				</tr>
				<tr height="30px;">
					<td class=title>선택</td>
					<!-- <td><input type="checkbox" name="" > </td> -->
					<td>
						<select name="car_ext">
							<option value="인천">인천</option>
							<option value="부산">부산</option>
							<option value="대전">대전</option>
							<option value="대구">대구</option>
							<option value="포천">포천</option>
							<option value="파주">파주</option>
						</select>
					</td>
					<td><input  type="text" name="car_num_area" id="car_num_area" size="7" class=text value="" placeholder="예)11"></td>
					<td><input  type="text" name="car_num_ko" id="car_num_ko" size="7" class=text value="" placeholder="예)허"></td>
					<td><input  type="text" name="car_num_first" id="car_num_first" size="15" class=text value="" placeholder="예)1234"></td>
					<td><input  type="text" name="car_num_last" id="car_num_last" size="15" class=text value="" placeholder="예)1236"></td>
					<td><input  type="text" name="reg_dt" id="reg_dt" size="24" class=text value="" placeholder="예)20171231"></td>
					<td><input  type="text" name="end_dt" id="end_dt"size="24" class=text value="" placeholder="미입력시 수령일자30일뒤"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<%-- <div style="float: left; margin-bottom: 10px; margin-top: 30px;"><label><i class="fa fa-check-circle"></i> 신규 자동차번호 목록</label></div>
<div style="position: relative; margin-top: 30px;" align="right">
<%if(auth_rw.equals("6")){ %>
	<input type="button" class="button" value="배정구분 일괄저장" onclick="javascript:regAllCarNoStat();">
	<input type="button" class="button" value="삭제" onclick="javascript:delCarNo();">
<%} %>
</div> --%>

<table width=100% border="0" cellspacing="0" cellpadding="0" style="margin-top: 45px;">
	<colgroup>
		<col width="20%">
		<col width="60%">
		<col width="20%">
	</colgroup>
	<tr>
		<td style="font-size: 17px;">
			<label><i class="fa fa-check-circle"></i> 신규 자동차번호 목록</label>
		</td>
		<td>
			&nbsp;&nbsp;&nbsp;<span style="font-weight: bold;">√</span>&nbsp;자리수&nbsp;
			<select id="car_no_leng" name="car_no_leng">
				<option value="" <%if(car_no_leng.equals("")){%>selected<%}%>>전체</option>
				<option value="7" <%if(car_no_leng.equals("7")){%>selected<%}%>>7자리</option>
				<option value="8" <%if(car_no_leng.equals("8")){%>selected<%}%>>8자리</option>
			</select>
			&nbsp;&nbsp;&nbsp;<span style="font-weight: bold;">√</span>&nbsp;발행관청&nbsp;
			<select id="sch_car_ext" name="sch_car_ext">
				<option value="" <%if(sch_car_ext.equals("")){%>selected<%}%>>전체</option>
				<option value="인천" <%if(sch_car_ext.equals("인천")){%>selected<%}%>>인천</option>
				<option value="부산" <%if(sch_car_ext.equals("부산")){%>selected<%}%>>부산</option>
				<option value="대전" <%if(sch_car_ext.equals("대전")){%>selected<%}%>>대전</option>
				<option value="대구" <%if(sch_car_ext.equals("대구")){%>selected<%}%>>대구</option>
				<option value="포천" <%if(sch_car_ext.equals("포천")){%>selected<%}%>>포천</option>
				<option value="파주" <%if(sch_car_ext.equals("파주")){%>selected<%}%>>파주</option>
				<option value="광주" <%if(sch_car_ext.equals("광주")){%>selected<%}%>>광주</option>
			</select>
			&nbsp;&nbsp;&nbsp;<span style="font-weight: bold;">√</span>&nbsp;수령일자&nbsp; 
			<input type="text" class=text name="sch_reg_dt_str" id="sch_reg_dt_str" size="11" value="<%=sch_reg_dt_str%>" onBlur="javascript:ChangeDT('sch_reg_dt_str')"> ~
			<input type="text" class=text name="sch_reg_dt_end" id="sch_reg_dt_end" size="11" value="<%=sch_reg_dt_end%>" onBlur="javascript:ChangeDT('sch_reg_dt_end')">
			&nbsp;&nbsp;&nbsp;<span style="font-weight: bold;">√</span>&nbsp;만기일자&nbsp; 
			<input type="text" class=text name="sch_end_dt_str" id="sch_end_dt_str" size="11" value="<%=sch_end_dt_str%>" onBlur="javascript:ChangeDT('sch_end_dt_str')"> ~
			<input type="text" class=text name="sch_end_dt_end" id="sch_end_dt_end" size="11" value="<%=sch_end_dt_end%>" onBlur="javascript:ChangeDT('sch_end_dt_end')">&nbsp;&nbsp;&nbsp;&nbsp;
			<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
		</td>
		<td>
			<div align="right">
			<%if(auth_rw.equals("6")){ %>
				<input type="button" class="button" value="배정구분 일괄저장" onclick="javascript:regAllCarNoStat();">
<!-- 				<input type="button" class="button" value="신형" onclick="javascript:regAllCarNoNew();"> -->
				<input type="button" class="button" value="구형" onclick="javascript:regAllCarNoNew();">
				<input type="button" class="button" value="KEEP" onclick="javascript:regAllCarNoKeep();">
				<input type="button" class="button" value="삭제" onclick="javascript:delCarNo();">
			<%} %>
			</div>	
		</td>
	</tr>
</table>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 
            <table  border=0 cellspacing=1 cellpadding="0" width=100%>
            	<colgroup>
            		<col width="4%;">
            		<col width="4%;">
            		<col width="9%;">
            		<col width="5%;">
            		<col width="7%;">            		
            		<col width="7%;">
            		<col width="5%;">
            		<col width="7%;">
            		<col width="5%;">
            		<col width="10%;">            		
            		<col width="6%;">
            		<col width="14%;">
            		<col width="10%;">
            		<col width="7%;">
            	</colgroup>
                <tr> 
                    <td class=title rowspan="2">연번</td>
                    <td class=title colspan="5">가용번호</td>				  
                    <td class=title colspan="2">배정구분</td>
                    <td class=title colspan="6">배정현황</td>
                </tr>
                <tr> 
                    <td class=title>선택</td>
                    <td class=title>자동차번호</td>
                    <td class=title>발행관청</td>
                    <td class=title>수령일자</td>
                    <td class=title>만기일자</td>
                    <td class=title>구분</td>
                    <td class=title>처리일자</td>
                    <td class=title>구분</td>
                    <td class=title>계약번호</td>
                    <td class=title>계약자</td>
                    <td class=title>차명</td>
                    <td class=title>차대번호</td>
                    <td class=title>등록일자</td>
                </tr>
<%if(lists.size() > 0){
	for(int i =0; i < lists.size() ; i++){
		Hashtable list = (Hashtable)lists.elementAt(i);%>
                <tr> 
                    <td class=title><%=i+1%></td>
                    <td align="center"><input type="checkbox" name="ch_cd" value="<%=list.get("SEQ")%>//<%=list.get("CAR_NO")%>"></td>
                    <td align="center">
                   	<%if (list.get("NEW_LICENSE_PLATE_YN").equals("N")) {%><span style="color: red;">[구형]</span><%}%>
                    <%if(list.get("KEEP_YN").equals("Y")){%>
                    	<a href="javascript:pop_keep_etc('<%=list.get("CAR_NO")%>','<%=list.get("SEQ")%>');" onMouseOver="window.status=''; return true" title='<%=list.get("KEEP_ETC")%>'><%=list.get("CAR_NO")%></a>
                    <%}else{%>
                    	<%=list.get("CAR_NO")%>
                    <%}%>
                    </td>
                    <td align="center"><%=list.get("CAR_EXT")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2((String)list.get("REG_DT"))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2((String)list.get("END_DT"))%></td>
                    <td align="center">
                    	<input type="hidden" name="seq" value="<%=list.get("SEQ")%>">
                    	<select name="car_no_stat" id="car_no_stat">
                    		<option value="" <%if(list.get("CAR_NO_STAT").equals("")||list.get("CAR_NO_STAT")==null){%>selected<%}%>></option>
                    		<option value="1" <%if(list.get("CAR_NO_STAT").equals("1")){%>selected<%}%>>신규</option>
                    		<option value="2" <%if(list.get("CAR_NO_STAT").equals("2")){%>selected<%}%>>대차</option>
                    		<option value="3" <%if(list.get("CAR_NO_STAT").equals("3")){%>selected<%}%>>대기</option>
                    		<option value="4" <%if(list.get("CAR_NO_STAT").equals("4")){%>selected<%}%>>반납</option>
                    		<option value="5" <%if(list.get("CAR_NO_STAT").equals("5")){%>selected<%}%>>말소</option>
                    	</select>
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2((String)list.get("UPD_DT"))%></td>
                    <td align="center">
<%		if(list.get("AUTO_YN").equals("해지")){%><a href="#" style="color: red;" onclick="javascript:dropCont('<%=list.get("CAR_NO")%>');"><%=list.get("AUTO_YN")%></a><%}else{%><%=list.get("AUTO_YN")%><%}%>                    
                    </td>
<%		if(!list.get("RENT_L_CD").equals("") && list.get("RENT_L_CD") !=  null){	
			
			Vector detailLists = sc_db.getNewCarNumDetailList((String)list.get("RENT_L_CD"));
			if(detailLists.size() > 0){
				for(int j =0; j < 1 ; j++){
					Hashtable detailList = (Hashtable)detailLists.elementAt(j);		%>		                    
                    <td align="center"><%=detailList.get("RENT_L_CD")%></td>
                    <td align="center"><%=detailList.get("REG_NM")%></td>
                    <td align="center"><%=detailList.get("CAR_NM")%></td>
                    <td align="center"><%=detailList.get("CAR_NUM")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2((String)detailList.get("REG_DT"))%></td>
<%				}
			}else{
%>
					<td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
<%				
			}
			
		}else{ 	%>
					<td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
<%		} 	%>                    
                 </tr>
<% 	}
}else{%>
                 <tr> 
                     <td colspan="14" align="center">등록된 자료가 없습니다.</td>
                 </tr>
<%}%>
            </table>
        </td>
    </tr>
</table>
</form>
<div style="margin-top: 10px;"> ※ 일괄(자동, 지정제외한)처리선택(신규, 반납:익일현황에서는 자동 삭제됨)</div>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
