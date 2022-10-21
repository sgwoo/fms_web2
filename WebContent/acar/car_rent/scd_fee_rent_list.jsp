<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":AddUtil.replace(request.getParameter("st_dt"),"-","");
	String end_dt 	= request.getParameter("end_dt")==null?	"":AddUtil.replace(request.getParameter("end_dt"),"-","");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(rent_mng_id, rent_l_cd);
	
	//거래처정보
	ClientBean client = al_db.getClient(String.valueOf(base.get("CLIENT_ID")));
	
	Vector vt = a_db.getContList_20160614("99", String.valueOf(base.get("FIRM_NM")), andor, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt);		
	int cont_size = vt.size();
	 
  	String dot_auth = "";
  	String tax_auth = "";
  	String car_auth = "";
  	
  	if (nm_db.getWorkAuthUser("관리자모드",user_id)||nm_db.getWorkAuthUser("계약봉투점검자", user_id)) {
  		dot_auth = "Y";
  	}
  	
  	if (nm_db.getWorkAuthUser("개별소비세담당",user_id)) {
  		tax_auth = "Y";
  	}
  	
  	if (nm_db.getWorkAuthUser("계약봉투점검자",user_id)||nm_db.getWorkAuthUser("본사출납", user_id)) {
  		car_auth = "Y";
  	}
  	
  	if (nm_db.getWorkAuthUser("전산팀",user_id)) {
  		dot_auth = "Y";
  		tax_auth = "Y";
  		car_auth = "Y";
  	}
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><!-- 호환성 보기 추가시 화면이 깨지는 현상 수정 2018.04.04 -->
<title>FMS - 계약현황</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.button_style:hover {
    background-color: #525D60;
}
.button_style {
	background-color: #6d758c;
    font-size: 12px;
    cursor: pointer;
    border-radius: 2px;
    color: #fff;
    border: 0;
    outline: 0;
    padding: 5px 8px;
    margin: 3px;
}
.button_style2 {
	background-image: linear-gradient(#919191, #787878);
    font-size: 10px;
    font-weight: bold;
    cursor: pointer;
    border-radius: 3px;
    color: #FFF;
    border: 0;
    outline: 0;
    padding: 5px 8px;
    margin: 3px;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">
<!--

	//전체선택 및 해제
	function AllSelect() { 
		var fm = document.form1;
		var check_val_length = document.getElementsByName("check_value").length;
		if (fm.ch_all.checked == true) {
			for (var i = 0; i < check_val_length; i++) {
				if (check_val_length == 1) {
					fm.check_value.checked = true;
				} else {
					fm.check_value[i].checked = true;
				}
			}
		} else {
			for (var z = 0; z < fm.check_value.length; z++) {
				if (check_val_length == 1) {
					fm.check_value.checked = false;
				} else {
					fm.check_value[z].checked = false;
				}
			}
		}
	}
	
	//대여료 스케줄 개별 인쇄화면
	function print_view(rent_mng_id, rent_l_cd) {
		var fm = document.form1;
		var stamp_yn = "";

		if (fm.stamp_yn.checked == true) {
			stamp_yn = "Y";
		} else {
			stamp_yn = "N";
		}
		
		var SUBWIN="./scd_fee_print2.jsp?rent_mng_id=" + rent_mng_id + "&rent_l_cd=" + rent_l_cd + "&stamp_yn=" + stamp_yn;
		
		alert("인쇄미리보기로 페이지 확인후 출력하시기를 권장합니다.");
		
		window.open(SUBWIN, "_blank", "left=100, top=100, width=950, height=800, scrollbars=yes");
	}
	
	//선택출력하기
	function print_view_all() {
		var fm = document.form1;
		var cnt = 0;
		var idnum = "";
		for (var i = 0; i < fm.elements.length; i++) {
			var ck = fm.elements[i];
			if (ck.name == "check_value") {
				if (ck.checked == true) {
					cnt++;
					idnum = ck.value;
				}
			}
		}
		
		if (cnt == 0) {
		 	alert("인쇄할 계약을 선택해주세요.");
			return;
		} else {
			alert("인쇄미리보기로 페이지 확인후 출력하시기를 권장합니다.");
		}
		
		var url = "./scd_fee_check_print2.jsp";
		var title = "openPop";
		var status = "left=100, top=100, width=950, height=800, scrollbars=yes";
		window.open("", title, status); //window.open(url, title, status); window.open 함수에 url을 앞에와 같이
        
		fm.target = title;
        fm.action = url;
        fm.method = "post";
        fm.submit();	
	}
	
	//개별메일발송
	function send_mail(rent_mng_id, rent_l_cd) {
		var fm = document.form1;
		fm.rent_mng_id.value = rent_mng_id;
		fm.rent_l_cd.value = rent_l_cd;

        if (confirm("메일을 발송 하시겠습니까?")) {
			fm.send_type.value = "single";

			fm.target = "i_no";
			fm.action = "/acar/car_rent/scd_fee_rent_list_a.jsp";
	        fm.method = "post";
	        fm.submit();
		}
	}

	//선택메일발송
	function send_mail_all() {
		var fm = document.form1;
		var cnt = 0;
		var idnum = "";
		for (var i = 0; i < fm.elements.length; i++) {
			var ck = fm.elements[i];
			if (ck.name == "check_value") {
				if (ck.checked == true) {
					cnt++;
					idnum = ck.value;
				}
			}
		}

		if (cnt == 0) {
		 	alert("메일을 발송할 계약을 선택해주세요.");
			return;
		} else {
			if (confirm("메일을 발송 하시겠습니까?")) {
				fm.send_type.value = "multi";
				
				fm.target = "i_no";
				fm.action = "/acar/car_rent/scd_fee_rent_list_a.jsp";
		        fm.method = "post";
		        fm.submit();
			}
		}
	}
	
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name="cmd" value="ing">
<input type='hidden' name="send_type" value="">
<input type='hidden' name="idx" value="">
<input type='hidden' name="rent_mng_id" value="">
<input type='hidden' name="rent_l_cd" value="">
<input type='hidden' name="car_mng_id" value="">
<input type="hidden" name="firm_nm" value="<%=base.get("FIRM_NM")%>">
<!-- 중간부분 -->
<table width=950 border=0 cellspacing=0 cellpadding=0 style="padding: 0px 0px 0px 10px;">                            
    <tr>
        <td height=10></td>
    </tr>
    <tr>
        <td width=1250 valign=top>
            <table width=1250 border=0 cellspacing=0 cellpadding=0>
                <!-- 제목바 -->
                <tr>
                    <td>
                        <table width=1250 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td>
	                            	<span style="font-size: 16px; font-weight: bold;"><%=base.get("FIRM_NM")%> 고객님의 계약 현황 입니다.</span>
                                </td>
            				</tr>
        				</table>
    				</td>
				</tr>
				<!-- 제목바 -->
				<tr>
				    <td height=20></td>
				</tr>
				<!-- 사용설명 -->
				<tr>
				    <td align=center>
				        <table width=1250 border=0 cellspacing=0 cellpadding=0>
				            <tr>
				                <td height=22>*&nbsp;<span style="color: red;"><%=AddUtil.getDate()%></span> 현재를 기준으로 조회된 계약현황입니다.</td>
							</tr>
				            <tr>
				                <td height=22>*&nbsp;대여료 스케줄 화면에서 <span style="color: red;">인쇄 미리보기시 내용이 용지크기에 맞지 않을 경우</span> 아래와 같이 설정 해주세요.</td>
							</tr>
				            <tr>
				                <td height=22>*&nbsp;<span style="color: red;">크롬(Chrome)</span> : 마우스 우클릭 > 인쇄 > 설정 더보기 > 여백 및 배율 맞춤 으로 설정.</td>
							</tr>
				            <tr>
				                <td height=22>*&nbsp;<span style="color: red;">익스플로러(explorer)</span> : 마우스 우클릭 > 인쇄 미리 보기 > 설정(톱니바퀴모양) > 크기에 맞게 축소 사용 에 체크.</td>
							</tr>
							<tr>
							    <td height=10></td>
							</tr>
				            <tr>
				                <td height=22>*&nbsp;<span style="color: red; font-weight: bold;">대여료스케줄 작성이 되지 않은 계약건은 인쇄 및 메일발송이 불가 합니다.</span></td>
							</tr>
				            <tr>
				                <td height=22>*&nbsp;<span style="color: red; font-weight: bold;">이름 및 이메일 정보는 한건의 계약정보를 통해 조회된 거래처 담당자 정보입니다.</span></td>
							</tr>
				            <tr>
				                <td height=22>*&nbsp;<span style="color: red; font-weight: bold;">장기대여스케줄안내문을 요청하여 받고자하는 거래처 담당자와 다를 수 있습니다. 이메일 발송전 받고자하는 거래처 담당자를 반드시 확인 해주세요.</span></td>
							</tr>
							<tr>
							    <td height=10></td>
							</tr>
				        </table>
				    </td>
				</tr>
				<!-- 사용설명 -->
				<tr>
				    <td height=10></td>
				</tr>
				<tr>
					<td align="right">
						<input type="checkbox" name="stamp_yn" id="stamp_yn" value="Y" checked><label for="stamp_yn">직인표시</label>
						&nbsp;&nbsp;&nbsp;
						<span style="font-weight: bold;">이름&nbsp;:&nbsp;</span>
						<input type="text" size="15" name="con_agnt_nm" value="<%=client.getCon_agnt_nm()%>" maxlength="20" class="text">
						&nbsp;&nbsp;&nbsp;
						<span style="font-weight: bold;">이메일&nbsp;:&nbsp;</span>
						<input type="text" size="40" name="con_agnt_email" value="<%=client.getCon_agnt_email()%>" maxlength="30" class="text">
						&nbsp;&nbsp;&nbsp;
						<input class="button_style" type="button" value="대여료 스케줄 선택 인쇄" onclick="print_view_all();">
						<input class="button_style" type="button" value="대여료 스케줄 선택 메일발송" onclick="send_mail_all();">
					</td>
				</tr>
				<tr>
				    <td height=10></td>
				</tr>
				<tr>
				    <td>
				        <table width=1250 border=0 cellpadding=0 cellspacing=1 bgcolor=a6b1d6>
				            <tr>
				            	<td width=30 class=title height=25>연번</td>
				            	<td width=30 class=title>
				            		<input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();">
				            	</td>				            	
				                <td width=40 class=title>구분</td>
				                <td width=80 class=title>계약번호</td>
				                <td width=70 class=title>계약일</td>
				                <td width=70 class=title>차량번호</td>
				                <td width=100 class=title>차종</td>
				                <td width=70 class=title>최종등록일</td>
				                <!-- <td width=130 class=title>차량이용자</td> -->
				                <td width='80' class='title'>해지구분</td>
								<td width='70' class='title'>계약구분</td>
								<td width='70' class='title'>차량구분</td>
								<td width='70' class='title'>용도구분</td>
								<td width='70' class='title'>관리구분</td>
				                <td width=60 class=title>대여기간</td>
				                <td width=70 class=title>대여개시일</td>
				                <td width=70 class=title>계약만료일</td>
				                <td width=110 class=title>대여료스케줄</td>
				            </tr>
							<%
							for (int i = 0; i < cont_size; i++) {
								Hashtable ht = (Hashtable)vt.elementAt(i);
								
								//대여갯수 카운터
								int fee_count	= af_db.getFeeCount(String.valueOf(ht.get("RENT_L_CD")));
								String rent_st = String.valueOf(fee_count);
								
								//기존대여스케줄 대여횟수 최대값
								int max_fee_tm 	= a_db.getMax_fee_tm(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), rent_st);
								//System.out.println(max_fee_tm);
							%>
							<tr>
							    <td class=content height=25 align=center><%=i+1%></td>
							    <td class=content height=25 align=center>
							    	<%-- <%if (!ht.get("RENT_START_DT").equals("")) {%> --%>
							    	<%if (max_fee_tm > 0) {%>
							    	<input type="checkbox" name="check_value" value="<%=ht.get("RENT_MNG_ID")%>_<%=ht.get("RENT_L_CD")%>_<%=ht.get("RENT_ST")%>">
							    	<%}%>
							    </td>
							    <td class=content height=25 align=center>
							    	<%if (String.valueOf(ht.get("USE_YN")).equals("")) {%>
                           				<%=ht.get("SANCTION_ST")%>
                       				<%} else if (String.valueOf(ht.get("USE_YN")).equals("Y")) {%>
                       					진행
                       				<%} else if (String.valueOf(ht.get("USE_YN")).equals("N")) {%>
                       					해지
                       				<%}%>
							    </td>
								<td class=content align=center><%=ht.get("RENT_L_CD")%></td>
								<td class=content align=center><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
								<td class=content align=center>
									<span class=style8><%=ht.get("CAR_NO")%></span>
								</td>
								<td class=content align=center><font color=4d4d4d><%=ht.get("CAR_NM")%></font></td>
								<td class=content align=center><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
								<%-- <td class=content align=center><span class=style8><%=ht.get("MGR_NM")%></span></td> --%>
																
								<td width='80' align='center'><%=ht.get("CLS_ST")%></td>
								<td width='70' align='center'>
								<%if (String.valueOf(ht.get("CNG_ST")).equals("")) {%>
									<%if (String.valueOf(ht.get("EXT_ST")).equals("")) {%>
											<%=ht.get("RENT_ST")%>
									<%} else {%>
											<%=ht.get("EXT_ST")%>
									<%}%>
								<%} else {%>
									<%if (String.valueOf(ht.get("EXT_ST2")).equals("")) {%>
											<%=ht.get("CNG_ST")%>
									<%} else {%>
											<%=ht.get("EXT_ST2")%>
									<%}%>
								<%}%>
								</td>
								<td width='70' align='center'><%=ht.get("CAR_GU")%></td>
								<td width='70' align='center'><%=ht.get("CAR_ST")%></td>
								<td width='70' align='center'><%=ht.get("RENT_WAY")%></td>	
								
								<td class=content align=center><%if(!String.valueOf(ht.get("CON_MON")).equals("")){%><%=ht.get("CON_MON")%>개월<%}else{%>-<%}%></td>
								
								<td class=content align=center><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
								<td class=content align=center><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
								<td class=content align=center>
									<%-- <%if (!ht.get("RENT_START_DT").equals("")) {%> --%>
							    	<%if (max_fee_tm > 0) {%>
									<input type="button" class="button_style" value="인쇄" onclick="print_view('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>');"> 
									<input type="button" class="button_style" value="메일" onclick="send_mail('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>');"> 
									<%}%>
								</td>
							</tr>
							<%}%>
							<%if (cont_size == 0) {%>
							<tr>
								<td height=25 colspan="11" align=center class=content>해당 데이타가 없습니다. </td>
							</tr>
							<%}%>
       					</table>
    				</td>
				</tr>
				<%-- 
				<%if (vt_size > 0) {%>
				<tr>
					<td height=25 align="right"><a href="javascript:ListPrint()"><img src="../../sub/images/button_print.gif" align=absMiddle border=0></a></td>
				</tr>
				<%}%> 
				--%>
			</table>
		</td>
    </tr>
</table>
<!-- 중간부분 -->
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" noresize></iframe>
</body>
</html>
