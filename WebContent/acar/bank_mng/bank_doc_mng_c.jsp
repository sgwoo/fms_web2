<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*,  acar.user_mng.*, acar.estimate_mng.*"%>
<%@ page import="acar.partner.*" %>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "07");	
	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String s_cpt = request.getParameter("s_cpt")==null?"":request.getParameter("s_cpt");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	String bank_id = "";
	String bank_nm = "";
	String fund_yn = "";
	
	String cmd = "";
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	Serv_EmpDatabase se_db = Serv_EmpDatabase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);

	//대출신청 리스트
	Vector FineList = FineDocDb.getBankDocListsH(doc_id);
		
	Vector PFineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "HEAD", "Y");
	int user_size = users.size();
	Vector users2 = c_db.getUserList("", "", "BODY", "Y");
	int user_size2 = users2.size();
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	//변수
	String var1 = e_db.getEstiSikVarCase("1", "", "bank1");//담당부서장
	String var2 = e_db.getEstiSikVarCase("1", "", "bank2");	//담당자	
	String var3 = e_db.getEstiSikVarCase("1", "", "bank_app1");//첨부서류1
	String var4 = e_db.getEstiSikVarCase("1", "", "bank_app2");//첨부서류2
	String var5 = e_db.getEstiSikVarCase("1", "", "bank_app3");//첨부서류3
	String var6 = e_db.getEstiSikVarCase("1", "", "bank_app4");//첨부서류4
	String var7 ="";
	
	 if  (Integer.parseInt(FineDocBn.getDoc_dt()) > 20141204) {	
		 var7 = e_db.getEstiSikVarCase("1", "", "bank_app6");//첨부서류5
	 } else {
		 var7 = e_db.getEstiSikVarCase("1", "", "bank_app5");//첨부서류5
	} 
	
	long amt_tot =0;
	long amt_tot2 = 0; //설정금액 합계
	long amt_tot3 = 0; //구입가격 합계
	int car_su = 0; //차량대수
	double amt1_tot = 0; //등록세
	double amt2_tot = 0; //증지세
	
	long loan_amt1 = 0;
	long loan_amt2 = 0;
	
			
	//대출 담당자
	Vector vt = se_db.getServ_empList("", Integer.toString(FineDocBn.getSeq()), "1", "", FineDocBn.getOff_id(), "all");
	int vt_size = vt.size();	
		
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	function sms_send(emp_nm, mtel){
		var SUBWIN="/acar/sms_gate/sms_mini_gate.jsp?auth_rw=<%= auth_rw %>&destname="+emp_nm+"&destphone="+mtel;
		window.open(SUBWIN, "sms_send", "left=100, top=120, width=500, height=400, scrollbars=no");
	}

	//대출내역 계약서 출력
	function ObjectionPrintAll(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print_all.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrintAll", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//대출내역 계약서 출력(테스트)
	function ObjectionPrintAllTest(){
		var fm = document.form1;
		var SUMWIN = "";
		var doc_id = encodeURIComponent('<%=doc_id%>',"EUC-KR");
		var chk = document.getElementsByName("chk")[0].value;
		SUMWIN="https://fms3.amazoncar.co.kr/acar/mng_pdf/objection_print_all2.jsp?doc_id="+doc_id+"&chk="+chk;	
		window.open(SUMWIN, "ObjectionPrintAll", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	
	//대출내역 차량등록증 출력
	function ObjectionPrintAll2(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print_reg_all.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrintAll", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	//대출내역 세금계산서 출력
	function ObjectionPrintAll3(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print_tax_all.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrintAll", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//대출내역서 출력
	function ObjectionPrint(){
		var fm = document.form1;
		var SUMWIN = "";
		if( fm.bank_id.value =="0026"  ){
			SUMWIN="objection_print1.jsp?doc_id=<%=doc_id%>";	
		} else if( fm.bank_id.value =="0083"  ){
				SUMWIN="objection_print4.jsp?doc_id=<%=doc_id%>";		
		} else {
			SUMWIN="objection_print.jsp?doc_id=<%=doc_id%>";	
		}	
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
		//대출내역서 excel출력 - 현대캐피탈 대출발생처리시 특이내역처리 (20220617)
	function ToExcel(){
		var fm = document.form1;
		var SUMWIN = "";
		
		if( fm.bank_id.value =="0026" ){
			SUMWIN="objection_excel_print1.jsp?doc_id=<%=doc_id%>";	
		} else if( fm.bank_id.value =="0083"  ){
			SUMWIN="objection_excel_print4.jsp?doc_id=<%=doc_id%>";		
		} else if( fm.bank_id.value =="0011" & fm.card_yn.value =="Y" ){
			SUMWIN="objection_excel_print5.jsp?doc_id=<%=doc_id%>";			
		} else {
			SUMWIN="objection_excel_print.jsp?doc_id=<%=doc_id%>";	
		}
				
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
		//계약서출력
	function ToExcel1(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_excel1_print.jsp?doc_id=<%=doc_id%>";	
		
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//위임장출력
	function jPrint(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="j.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "j", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//양도통지서출력
	function j1Print(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="j_1.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "j", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//채권양도통지위임장출력
	function j20121203Print(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="j20121203.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "j20121203", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//채권양도 통지서출력
	function j120121203Print(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="j_120121203.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "j_120121203", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//출력하기
	function FineDocPrint(){
		var fm = document.form1;
		var SUMWIN = "";
			
		if(fm.bank_id.value =="0026" || fm.bank_id.value =="0037"  || fm.bank_id.value =="0033"   || fm.bank_id.value =="0029"  || fm.bank_id.value =="0025"   ){
			SUMWIN="bank_doc_print1.jsp?doc_id=<%=doc_id%>";	
		}else{
			SUMWIN="bank_doc_print.jsp?doc_id=<%=doc_id%>";	
		}
		
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
	
	//관리번호 출력
	function j2Print(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="j_2.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=1000, height=800, scrollbars=yes, status=yes");			
	}
	
	//공동담보 목록 출력
	function ObjectionPrint10(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print10.jsp?doc_id=<%=doc_id%>";	 
		window.open(SUMWIN, "ObjectionPrint", "left=50, top=50, width=750, height=804, scrollbars=yes, status=yes");		
	}
	
	//목록보기
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "bank_doc_mng_frame.jsp";
		fm.submit();
	}			
	//수정하기
	function fine_update(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "bank_doc_mng_u.jsp";
		fm.submit();
	}	
	
		//삭제하기
	function fine_del(){
		var fm = document.form1;
		if(!confirm('삭제하시겠습니까?')){	return;	}
		fm.target = "d_content";
		fm.action = "bank_doc_mng_d_a.jsp";
		fm.submit();
	}
	
	
	//수정하기
	function fine_upd(){
		window.open("bank_doc_mng_u.jsp?doc_id=<%=doc_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>", "REG_FINE_GOV", "left=100, top=200, width=860, height=600, scrollbars=yes");
	}

	function updatelist(){
		var fm = document.form1;	
		var bank_id = <%=FineDocBn.getGov_id()%>;
		window.open("bank_doc_list_u.jsp?fund_yn=<%=FineDocBn.getFund_yn()%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&doc_id=<%=doc_id%>&bank_id=<%=FineDocBn.getGov_id()%>&bank_nm=<%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%>", "CHANGE_ITEM", "left= 50, top=50, width=1100, height=800, scrollbars=yes");
	
	}	
	
	function Regynyn(doc_id){
	var fm = document.form1;
	fm.cmd.value = "y";
	fm.action = "bank_doc_mng_u_a.jsp?doc_id="+doc_id;	
	fm.target = "i_no";
	fm.submit();
	}
	
	function Regcltr_chk(doc_id){
	var fm = document.form1;
	fm.cmd.value = "cltr_chk";
	fm.action = "bank_doc_mng_u_a.jsp?doc_id="+doc_id;	
	fm.target = "i_no";
	fm.submit();
	}
	
	
	function bank_massges_reg(){
		var fm = document.form1;
		if(!confirm('쿨메신져로 메세지를 보내시겠습니까?')){	return;	}
		fm.cmd.value = "m";
		fm.target = "d_content";
		fm.action = "bank_doc_reg_sc_a.jsp";
		fm.submit();
	}
	
	
	//조사표 출력
	function ObjectionPrint2(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print2_excel.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrintAll", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//실행리스트 출력
	function ObjectionPrint3(){
		var fm = document.form1;
		var SUMWIN = "";
		SUMWIN="objection_print3_excel.jsp?doc_id=<%=doc_id%>";	
		window.open(SUMWIN, "ObjectionPrintAll", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");			
	}
	
	//공문분할인쇄
	function ObjectionPrintalldiv(){
	
		var fm = document.form1;
		
		var start_num 	= 0;
		var end_num 	= 0;
	
		
		if(fm.doc_print_st.value == '' && toInt(fm.d_start_num.value) >0){
			start_num 	= toInt(fm.d_start_num.value);
			end_num 	= toInt(fm.d_end_num.value);			
		}else{ 
			if(fm.doc_print_st.value == ''){ alert('분할인쇄 구분을 선택하십시오.'); return; }
			var select_nums = fm.doc_print_st.value.split("~");				
			start_num 	= toInt(select_nums[0]);
			end_num 	= toInt(select_nums[1]);			
		}		
		
		//alert(fm.doc_print_st.value);
		
		fm.start_num.value 	= start_num;
		fm.end_num.value 	= end_num;		
		fm.target = "_blank";
		
		fm.action = "objection_print_all_div.jsp";		
		fm.submit();	
		
	}
	
	
//-->
</script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_cpt' value='<%=s_cpt%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='bank_id' value='<%=FineDocBn.getGov_id()%>'>
<input type='hidden' name='fund_yn' value='<%=FineDocBn.getFund_yn()%>'>
<input type='hidden' name='bank_nm' value='<%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%>'>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='start_num' value=''>
<input type='hidden' name='end_num' value=''>
<input type='hidden' name='card_yn' value='<%=FineDocBn.getCard_yn()%>'> 

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 구매자금관리 > <span class=style5>대출취급 신청공문관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td align="right">
        <% if (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("영업수당관리자",user_id)   || nm_db.getWorkAuthUser("대출관리자",user_id)   || nm_db.getWorkAuthUser("CMS관리",user_id) ||  nm_db.getWorkAuthUser("출금담당",user_id)    ){%>
        <a href="javascript:fine_del();"><img src=../images/center/button_delete.gif align=absmiddle border=0></a>&nbsp;
	    <a href="javascript:fine_upd();"><img src=../images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
	    <% } %>
	    <a href="javascript:go_list();"><img src=../images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=15%>문서번호</td>
                    <td width=85%>&nbsp;&nbsp;<%=FineDocBn.getDoc_id()%></td>
                </tr>
                <tr> 
                    <td class='title'>시행일자</td>
                    <td>&nbsp;&nbsp;<%=AddUtil.getDate3(FineDocBn.getDoc_dt())%>
                    <%if(FineDocBn.getFund_yn().equals("Y")) {%>&nbsp;&nbsp;&nbsp;&nbsp;[자금]&nbsp;리스<%} %>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>수신</td>
                    <td>&nbsp;&nbsp;<%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%></td>
                </tr>
                <tr> 
                    <td class='title'>참조</td>
                    <td>&nbsp;&nbsp;<%=FineDocBn.getMng_dept()%></td>
                </tr>
                <tr> 
                    <td class='title'>제목</td>
                    <td>&nbsp;&nbsp;<%=FineDocBn.getTitle()%></td>
                </tr>
                <tr> 
                    <td class='title'>내용</td>
                    <td style='height:36'>&nbsp;&nbsp;1. 귀 사의 무궁한 발전을 기원합니다. <br>
                	   &nbsp;&nbsp;2. 아래와 같이 자동차 구입에 필요한 자금을 요청하오니, 검토 후 실행하여 주십시오.
                
                    </td>
                </tr>		  
                <tr> 
                    <td class='title'>첨부</td>
                    <td>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc1" value="Y" disabled <%if(FineDocBn.getApp_doc1().equals("Y"))%>checked<%%>><%=var3%><br>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc2" value="Y" disabled <%if(FineDocBn.getApp_doc2().equals("Y"))%>checked<%%>><%=var4%><br>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc3" value="Y" disabled <%if(FineDocBn.getApp_doc3().equals("Y"))%>checked<%%>><%=var5%><br>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc4" value="Y" disabled <%if(FineDocBn.getApp_doc4().equals("Y"))%>checked<%%>><%=var6%><br>
        			&nbsp;&nbsp;<input type="checkbox" name="app_doc5" value="Y" disabled <%if(FineDocBn.getApp_doc5().equals("Y"))%>checked<%%>><%=var7%>
        			</td>
                </tr>	
                <tr> 
                    <td class='title'>근저당설정</td>
                   <td ><font color=red>&nbsp; 대출금의 
                      <%=FineDocBn.getCltr_rat()%>
                      (%)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;또는 설정건당 <%=FineDocBn.getCltr_amt()%>원</font> &nbsp;&nbsp; <font color=blue>*!!!!!반드시 실근저당설정율과 비교해보세요!!!!</font>
                    </td>
                </tr>
                
                <% if ( FineDocBn.getCard_yn().equals("Y")){ %>                
                <tr> 
                    <td class='title'>카등할부 승인일자</td>
                   <td>&nbsp;&nbsp<%=AddUtil.getDate3(FineDocBn.getApp_dt())%>&nbsp;&nbsp;              
                   </td>
                </tr>	  	  
                <% } %>
                  <tr> 
                    <td class='title'>CMS기관코드</td>
                   <td>&nbsp;&nbsp<%=FineDocBn.getCms_code()%>&nbsp;&nbsp; *전산실에서 사용합니다.             
                   </td>
                </tr>	  	
                	  		  
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
      
	<%if(!FineDocBn.getReq_dt().equals("")){%>
	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>근저당권설정비용 입금확인</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
					<td class='title' width="25%">등록세</td>
					<td class='title' width="25%">증지세</td>
					<td class='title' width="25%">발신일자</td>
					<td class='title' width="25%">환급일자</td>
				</tr>
				<tr>
					<td class='' align="right"><%=Util.parseDecimal(FineDocBn.getAmt1())%>원&nbsp;</td>
					<td class='' align="right"><%=Util.parseDecimal(FineDocBn.getAmt2())%>원&nbsp;</td>
					<td class='' align="center"><%=AddUtil.getDate3(FineDocBn.getReq_dt())%></td>
					<td class='' align="center"><%=AddUtil.getDate3(FineDocBn.getIp_dt())%></td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
        <td></td>
    </tr>
	<%}%>
	
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>당사</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width=15% class='title'>담당부서장</td>
                    <td width=30%>&nbsp;&nbsp;<select name='h_mng_id' disabled>
                        <option value="">없음</option>
                        <%	if(user_size > 0){
            						for (int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getH_mng_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                        <%		}
            					}		%>
                      </select></td>
                    <td width=15% class='title'>담당자</td>
                    <td width=40%>&nbsp;&nbsp;<select name='b_mng_id' disabled>
                        <option value="">없음</option>
                        <%	if(user_size2 > 0){
            						for (int i = 0 ; i < user_size2 ; i++){
            							Hashtable user = (Hashtable)users2.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getB_mng_id().equals((String)user.get("USER_ID")))%>selected<%%>><%=user.get("USER_NM")%></option>
                        <%		}
            					}		%>
                      </select></td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr> 
        <td align="right" colspan=2>
        	  <%if(FineDocBn.getPrint_dt().equals("")){%>
        	  <a href="javascript:FineDocPrint();"><img src=../images/center/button_print_gm.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        	  <%}else{%>
        	  <img src=../images/center/arrow_printd.gif align=absmiddle> : <a href="javascript:FineDocPrint();"><%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%> (<%=c_db.getNameById(FineDocBn.getPrint_id(), "USER")%>)</a>&nbsp;&nbsp;
        	  <%}%>	  
				<a href="javascript:ObjectionPrintAll();"><img src=../images/center/button_print_gys.gif align=absmiddle border=0></a>&nbsp;
				<a href="javascript:ObjectionPrintAll2();">등록증</a>&nbsp;
				<a href="javascript:ObjectionPrintAll3();">세금계산서</a>&nbsp;
				<a href="javascript:ToExcel1();">계약서엑셀</a> 
				<a href="javascript:ObjectionPrint();"><img src=../images/center/button_dcnys.gif align=absmiddle border=0></a>&nbsp;
				[<a href="javascript:j20121203Print();">채권양도통지위임장</a>]
				[<a href="javascript:j120121203Print();">채권양도통지서</a>]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<!--<a href="javascript:jPrint();"><img src=../images/center/button_wij.gif align=absmiddle border=0></a>&nbsp;
				<a href="javascript:j1Print();"><img src=../images/center/button_ydtjs.gif align=absmiddle border=0></a>&nbsp;-->
				[<a href="javascript:ObjectionPrint10();">공동담보</a>]&nbsp; 
				<a href="javascript:j2Print();"><img src=../images/center/button_num_car.gif align=absmiddle border=0></a>&nbsp; 
				<a href="javascript:ToExcel();"><img src=../images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;  
				[<a href="javascript:ObjectionPrint2();">조사표</a>]&nbsp;  
				[<a href="javascript:ObjectionPrint3();">실행리스트</a>]
				
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>대출신청리스트&nbsp;<a href="javascript:updatelist()"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a></span>
		
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<span class=style2><select name='chk' id="chk">
                        <option value="1">계약서</option> 
                        <option value="2">세금계산서</option> 
                        <option value="3">자동차등록증</option>  
                        <option value="4">매매주문서</option> 분할인쇄 : 
                    </select>    
		<select name='doc_print_st'> 
		  <option value="">선택</option>
		<%	int max_num = 30;
			for(int i=0; i<PFineList.size(); i+=max_num){
				int start_num 	= i+1;
				int end_num 	= i+max_num;
				if(end_num>PFineList.size()) end_num = PFineList.size();  %>
		  <option value="<%=start_num%>~<%=end_num%>"><%=start_num%>~<%=end_num%></option>
		<%	}%>	
		</select>
		&nbsp;	
		기타선택 : 
		<input type="text" name="d_start_num" size="2" class="text" value="">~<input type="text" name="d_end_num" size="2" class="text" value="">
		&nbsp;
		<a href="javascript:ObjectionPrintalldiv();"><img src="/acar/images/center/button_print_all.gif" align="absmiddle" border="0"></a></span>
		&nbsp;&nbsp;<a href="javascript:ObjectionPrintAllTest();">PDF로 출력</a>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				
		
		<img src=../images/center/icon_arrow.gif align=absmiddle><span class=style2>저당권 설정서류</span> &nbsp;
			<select name="yn">
				<option value="" <%if(FineDocBn.getRegyn().equals(""))%>selected<%%>>선택</option>
				<option value="Y" <%if(FineDocBn.getRegyn().equals("Y"))%>selected<%%>>완료</option>
				<option value="N" <%if(FineDocBn.getRegyn().equals("N"))%>selected<%%>>미비</option>
			</select>&nbsp;
			   <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>	
			<a href="javascript:Regynyn('<%=doc_id%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
			<% } %>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<img src=../images/center/icon_arrow.gif align=absmiddle><span class=style2>담보구분</span> &nbsp;
				<select name="cltr_chk">
					<option value="" <%if(FineDocBn.getCltr_chk().equals(""))%>selected<%%>>선택</option>
					<option value="1" <%if(FineDocBn.getCltr_chk().equals("1"))%>selected<%%>>개별</option>
					<option value="2" <%if(FineDocBn.getCltr_chk().equals("2"))%>selected<%%>>공동</option>
				</select>&nbsp;
				  <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>	
							<a href="javascript:Regcltr_chk('<%=doc_id%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
				  <% } %>
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="20%" colspan="2">상환조건</td>
                    <td class='title' rowspan="2" width="10%">구입대수</td>
                    <td class='title' rowspan="2" width="15%">구입가격</td>
                    <td class='title' colspan="2" width="30%">대출</td>
                    <td class='title' rowspan="2" width="15%">설정금액</td>
                    <td class='title' rowspan="2" width="10%">대출금리</td>
                </tr>
                <tr> 
                    <td class='title' width="10%" height="25" align="center" >기간</td>
                    <td class='title' width="10%" align="center" >방법</td>
                    <td class='title' width="15%" align="center" >금액</td>
                    <td class='title' width="15%" align="center" >실행일자</td>
                </tr>
                  <% if(FineList.size()>0){
        				for(int i=0; i<FineList.size(); i++){ 
        					Hashtable ht1 = (Hashtable)FineList.elementAt(i);
        					        				
        						amt_tot   += AddUtil.parseLong(String.valueOf(ht1.get("AMT3")));
        						amt_tot2  += AddUtil.parseLong(String.valueOf(ht1.get("AMT6")));
        						amt_tot3  += AddUtil.parseLong(String.valueOf(ht1.get("AMT2")));			
							        					
							 	car_su += AddUtil.parseLong(String.valueOf(ht1.get("AMT1")));
        		 %>					
                <tr align="center"> 
                    <td><%=ht1.get("PAID_NO")%>개월</td>			
                    <td><%=ht1.get("CAR_ST")%></td>
                    <td><%=ht1.get("AMT1")%></td>
                    <td align="right"><%=Util.parseDecimalLong(String.valueOf(ht1.get("AMT2")))%>&nbsp;</td>
                    <td align="right"><%=Util.parseDecimalLong(String.valueOf(ht1.get("AMT3")))%>&nbsp;</td>
                    <td><%=ht1.get("VIO_DT")%></td>
                    <td align="right"><%=Util.parseDecimalLong(String.valueOf(ht1.get("AMT6")))%>&nbsp;
<!--
<% if (    FineDocBn.getGov_id().equals("0044")  ||  FineDocBn.getGov_id().equals("0059")  ) { %>
 	<%=Util.parseDecimal(String.valueOf(FineDocListBn.getAmt3()  ))%>&nbsp;
<% } else if (    FineDocBn.getGov_id().equals("0018") ) { %>
 	<%=Util.parseDecimal(String.valueOf(FineDocListBn.getAmt4()  ))%>&nbsp; 	
 <% } else if (    FineDocBn.getGov_id().equals("0058") ) { %>
 	<%=Util.parseDecimal(String.valueOf((1000000 *FineDocListBn.getAmt1()) ))%>&nbsp; 		
<% } else { %>      
            <%=Util.parseDecimal(String.valueOf(FineDocListBn.getAmt3() / 2 ))%>&nbsp;
<% } %> -->                   
                    </td>
                    <td><%=ht1.get("SCAN_FILE")%></td>
                </tr>
				<input type='hidden' name='vio_dt' value='<%=ht1.get("VIO_DT")%>'>
                  <% 	}
				  
					amt1_tot = amt_tot2 * 0.002;
					amt2_tot = amt_tot2 * 0.004;
				  
				  	loan_amt1 = (long) amt1_tot;
					loan_amt1 = AddUtil.l_th_rnd_long(loan_amt1);
					loan_amt2 = (long)  amt2_tot;
					loan_amt2 = AddUtil.l_th_rnd_long(loan_amt2);
					
        			} %>
				<tr>
					<td class='title' colspan='2'> 대출금액 합계</td>
					<td align='center'><%=Util.parseDecimal(car_su)%> </td>
					<td align='right'><%=Util.parseDecimalLong(amt_tot3)%>원&nbsp; </td>
					<td align='right'><%=Util.parseDecimalLong(amt_tot)%>원&nbsp; </td>
					<input type='hidden' name='amt_tot' value='<%=Util.parseDecimalLong(amt_tot)%>'>	
					<td align='right' class='title'>설정금액 합계</td>
					<td align='right'><%=Util.parseDecimalLong(amt_tot2)%>원&nbsp; </td>
					<td align='right' class='title'></td>
				</tr>
            </table>
        </td> 
    </tr>
    <tr><td><font color=red>*실근저당설정율: 대출금의 <%= (double)  amt_tot2/ amt_tot *100 %> %</font></td></tr>
    <tr> 
        <td align="right"><%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	    담당자에게 메세지 보내기 :&nbsp;<a href='javascript:bank_massges_reg()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_msg.gif align=absmiddle border=0></a>
	    <%}%>&nbsp;</td>
    </tr>
    
    <% if ( vt_size > 0 ) { %> 
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>대출담당자</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
   
     <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
			<% for(int i=0; i< vt_size; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
			%>
			
				<tr>
					<td class="title" width="10%">성명</td>
					<td class="title" width="15%">부서</td>
					<td class="title" width="10%">직책</td>
					<td class="title" width="10%">대표전화</td>
					<td class="title" width="10%">직통전화</td>
					<td class="title" width="10%">팩스</td>
					<td class="title" width="10%">휴대폰</td>
				</tr>
				<tr>
					<td rowspan="4" colspan="1" align="center">
					<%=ht.get("EMP_NM")%>
					<%if(!String.valueOf(ht.get("EMP_LEVEL")).equals("")&&!String.valueOf(ht.get("POS")).equals("")){%><%=ht.get("POS")%><%}else{%><%=ht.get("POS")%><%=ht.get("EMP_LEVEL")%><%}%>
					</td>
					<td align="center"><%=ht.get("DEPT_NM")%></td>
					<td align="center"><%=ht.get("POS")%></td>
					<td align="center"><%=ht.get("EMP_TEL")%></td>
					<td align="center"><%=ht.get("EMP_HTEL")%></td>
					<td align="center"><%=ht.get("EMP_FAX")%></td>
					<td align="center"><a href="javascript:sms_send('<%=ht.get("EMP_NM")%>','<%=ht.get("EMP_MTEL")%>')"><%=ht.get("EMP_MTEL")%></a></td>
				</tr>
				<tr>
					<td rowspan="1" class="title">E-mail</td>
					<td class="title" width="10%">일괄발송구분</td>
					<td class="title" width="10%">최초등록</td>
					<td class="title" width="10%">변경등록</td>
					<td class="title" width="10%">담당업무</td>
					<td class="title" width="10%">유효구분</td>
				</tr>
				<tr>
					<td rowspan="1" align="center"><%=ht.get("EMP_EMAIL")%></td>
					<td align="center" ><%if(ht.get("EMP_EMAIL_YN").equals("N")){%>비대상<%}else{%>대상<%}%></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("UPT_DT")))%></td>
					<td align="center" ><%=ht.get("EMP_ROLE")%></td>
					<td align="center"><%if(ht.get("EMP_VALID").equals("1")){%>유효
					<%}else if(ht.get("EMP_VALID").equals("2")){%>부서변경
					<%}else if(ht.get("EMP_VALID").equals("3")){%>퇴직
					<%}else if(ht.get("EMP_VALID").equals("4")){%>무효
					<%}%>
					</td>
					
				</tr>
				<tr>
					<td class="title">주소</td>
					<td rowspan="1" colspan="6">&nbsp;&nbsp;(<%=ht.get("EMP_POST")%>)&nbsp;&nbsp;<%=ht.get("EMP_ADDR")%></td>
				</tr>
				<%}%>
			</table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <% } %>
    
</table>
</form>
</body>
</html>
