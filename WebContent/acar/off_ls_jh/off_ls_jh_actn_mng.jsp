<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="auction" class="acar.offls_actn.Offls_auctionBean" scope="page"/>
<jsp:useBean id="auction_re" class="acar.offls_actn.Offls_auction_reBean" scope="page"/>
<jsp:useBean id="auction_ban" class="acar.offls_actn.Offls_auction_banBean" scope="page"/>
<jsp:useBean id="olaBean" class="acar.offls_actn.Offls_actnBean" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="apprsl" scope="page" class="acar.offls_pre.Off_ls_pre_apprsl"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");

	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 		= request.getParameter("seq")==null?"01":request.getParameter("seq");
	String actn_cnt 	= request.getParameter("actn_cnt")==null?"":request.getParameter("actn_cnt");
	String flag 		= request.getParameter("flag")==null?"n":request.getParameter("flag");	//경매상태등록 여부 판단후 FootWin()실행 결정.
			
	olaBean 		= olaD.getActn_detail(car_mng_id);
	auction 		= olaD.getAuction(car_mng_id, seq);
	auction_re 		= olaD.getAuction_re(car_mng_id, auction.getActn_cnt());
	auction_ban 	= olaD.getAuction_ban(car_mng_id, auction.getActn_cnt());
	apprsl 			= olpD.getPre_apprsl(car_mng_id);

	int carpr 		= olaBean.getCar_cs_amt()+olaBean.getCar_cv_amt()+olaBean.getOpt_cs_amt()+olaBean.getOpt_cv_amt()+olaBean.getClr_cs_amt()+olaBean.getClr_cv_amt();
	
	double hp_pr 		= auction.getHp_pr();
	double hp_pr_per 	= (hp_pr*100)/carpr;
	
	String per_id 		= olaD.existsCar_mng_id(car_mng_id,auction.getActn_cnt());

	//전경매대비
	int pre_hp_pr 		= 0;
	double pre_hp_per 	= 0.0d;
	
	if((AddUtil.parseInt(auction.getSeq())-1)>0){
		pre_hp_pr 	= olaD.getPre_hp_pr(car_mng_id, seq);
		pre_hp_per 	= (hp_pr*100)/pre_hp_pr;
	}
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//차령계산(오늘날짜 - 최초등록일)
	Hashtable ht = olaD.getCar_old(olaBean.getInit_reg_dt());
	
	//권한
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "06", "03", "05");
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
//경매상태별 처리
function FootWin() {
	var theForm = document.form1;
<%if(seq.equals(olaD.getAuction_maxSeq(car_mng_id))){
	if(auction.getActn_st().equals("2")){
		if(!auction_re.getCar_mng_id().equals("")){%>
			theForm.action = "off_ls_jh_actn_mng_re.jsp";
		<%}else if(!auction_ban.getCar_mng_id().equals("")){%>
			theForm.action = "off_ls_jh_actn_mng_ban.jsp";
		<%}else{%>
			theForm.action = "off_ls_jh_sc_in_choi.jsp";
		<%}%>
	<%}else if(auction.getActn_st().equals("3")){%>
		theForm.action = "off_ls_jh_sc_in_per.jsp";
	<%}else if(auction.getActn_st().equals("4")){%>
		theForm.action = "off_ls_jh_sc_in_nak.jsp";
	<%}else{%>
		theForm.action="off_ls_jh_sc_in_nodis.jsp";
	<%}
}else{
	if(auction.getActn_st().equals("3")){%>		
		theForm.action = "off_ls_jh_sc_in_per.jsp";
	<%}else if(auction.getActn_st().equals("4")){%>	
		theForm.action = "off_ls_jh_sc_in_nak.jsp";
	<%}else if(auction.getActn_st().equals("2")){
		if(auction.getChoi_st().equals("1")){%>
			theForm.action = "off_ls_jh_actn_mng_re.jsp";
		<%}else if(auction.getChoi_st().equals("2")){%>
			theForm.action = "off_ls_jh_actn_mng_ban.jsp";
		<%}else if(auction.getChoi_st().equals("3")){%>
			theForm.action = "off_ls_jh_sc_in_per.jsp";
		<%}
	}
	else%>	theForm.action = "off_ls_jh_sc_in_nodis.jsp";
<%}%>
	theForm.target = "st_foot";
	theForm.submit();
}

	//개별상담
	function per_talk() {
		var fm = document.form1;
		fm.action = "off_ls_jh_sc_in_per.jsp";
		fm.target = "st_foot";
		fm.submit();
	}

	//경매관리 등록/수정
	function updAuction(ioru) {
	//document.domain = "amazoncar.co.kr";
		var fm = document.form1;
					
		var auction_dt = ChangeDate2(fm.actn_dt.value);
		
		var ama_rsn = fm.ama_rsn.value;
		var actn_rsn = fm.actn_rsn.value;
		
		var ama_rsn_check = true;
		var actn_rsn_check = true;
		
		if (ama_rsn != "") {
			var tempStr = ama_rsn;
			var tempStr2 = "";
			for (var i = 0; i < tempStr.length; i++) {
				tempStr2 = tempStr.charCodeAt(i);
                // 큰따옴표(") 특수문자 입력제한
				if (tempStr2 == 34) {
					ama_rsn_check = false;
				}
			}
		}
		
		if (actn_rsn != "") {
			var tempStr = actn_rsn;
			var tempStr2 = "";
			for (var i = 0; i < tempStr.length; i++) {
				tempStr2 = tempStr.charCodeAt(i);
				// 큰따옴표(") 특수문자 입력제한
				if (tempStr2 == 34) {
					actn_rsn_check = false;
				}
			}
		}
		
		//경매일 체크
		if (auction_dt == "") {
			alert("경매일을 입력해 주세요!");
			return;
		}
		
		//차량상태 평가요인 일부 특수문자 체크
		if (ama_rsn_check == false) {
			alert("경매관리 - 아마존카 평가요인 내용 중 사용할 수 없는\n큰따옴표(\")가 포함되어 있습니다. 확인해주세요.");
			return;
		}
		if (actn_rsn_check == false) {
			alert("경매관리 - 경매장 평가요인 내용 중 사용할 수 없는\n큰따옴표(\")가 포함되어 있습니다. 확인해주세요.");
			return;
		}

		if (ioru == "i") {
			if (!confirm('등록 하시겠습니까?')) { return; }
		} else if (ioru == "u") {
			if (!confirm('수정 하시겠습니까?')) { return; }
		}
<%if(nm_db.getWorkAuthUser("경매처리",user_id)){%>
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/off_ls_jh_actn_mng_upd2.jsp";
<%} else {%>
		fm.action = "off_ls_jh_actn_mng_upd.jsp";
<%}%>
		fm.target = "i_no";
		fm.submit();
	}

	//유찰로변경
	function cngUAuction() {
		var fm = document.form1;
		if(!confirm('변경 하시겠습니까?')){ return; }
		fm.action = "off_ls_jh_actn_mng_cngU.jsp";
		fm.target = "i_no";
		fm.submit();	
	}

	//신차대비희망소비자가 %
	function getHpprPer(val) {
		var fm = document.form1;
		
		var hp_pr 	= toInt(parseDigit(fm.hp_pr.value));
		var car_pr 	= toInt(parseDigit(fm.car_pr.value));
		var per 	= (hp_pr*100)/car_pr;
		
		fm.hp_pr_per.value = parseFloatCipher3(per, 2);

		return parseDecimal(val);
	}
	
	//실경매낙찰가 계산
	function set_janga() {	
		var fm = document.sh_form;
		var fm2 = document.form1;
		var auction_dt = ChangeDate2(fm2.actn_dt.value);
		if (auction_dt == "") {
			alert("경매일을 입력해 주세요!");
			return;
		}
		fm.rent_st.value 	= "1"; //재리스
		fm.rent_dt.value 	= fm2.actn_dt.value;
		fm.action = '/acar/secondhand/getSecondhandJanga.jsp';
		fm.target = '_blank';
		fm.submit();
	}
	
	//실경매낙찰가 계산 - 프로시저
	function set_OsAmt() {	
		var fm = document.sh_form;
		var fm2 = document.form1;
		var auction_dt = ChangeDate2(fm2.actn_dt.value);
		if(auction_dt == ""){ 
			alert("경매일을 입력해 주세요!"); 
			return;
		}	
		fm.rent_st.value 	= "1"; //재리스		
		fm.rent_dt.value 	= fm2.actn_dt.value;
		fm.action = '/acar/secondhand/getSecondhandOffls.jsp';
		fm.target = 'i_no';
		fm.submit();
	}	
	
	//실경매낙찰가 계산 이력 - 프로시저
	function set_OsAmt_h() {	
		var fm = document.sh_form;
		var fm2 = document.form1;
		var auction_dt = ChangeDate2(fm2.actn_dt.value);
		if(auction_dt == ""){ 
			alert("경매일을 입력해 주세요!"); 
			return;
		}	
		fm.rent_st.value 	= "1"; //재리스		
		fm.rent_dt.value 	= fm2.actn_dt.value;
		fm.action = '/acar/secondhand/getSecondhandOffls_result.jsp';
		fm.target = '_blank';
		fm.submit();
	}		
//-->
</script>
<body bgcolor="#FFFFFF" text="#000000" onload="javascript:FootWin()">
<form action='/acar/secondhand/getSecondhandBaseSet.jsp' name="sh_form" method='post'>
  <input type='hidden' name="car_mng_id"		value="<%=car_mng_id%>">  
  <input type='hidden' name="mode"			value="off_ls">    
  <input type='hidden' name="rent_dt"			value="">    
  <input type='hidden' name="rent_st"			value="">      
  <input type='hidden' name="a_b"			value="36">     
  <input type='hidden' name="fee_opt_amt"		value="0">
  <input type='hidden' name="cust_sh_car_amt"		value="">   
  <input type='hidden' name="sh_amt"			value="0">     
  <input type='hidden' name="today_dist"		value="<%=apprsl.getKm()%>">
  <input type='hidden' name="jg_b_dt"			value="">
  <input type='hidden' name="a_j"			value="">  
</form>
<%if(nm_db.getWorkAuthUser("경매처리",user_id)){%>
<form action="" name="form1" method="POST" enctype="multipart/form-data">
<%}else{%>
<form action="" name="form1" method="post">
<%}%>

<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="gubun" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <td width="720"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>경매관리</span>&nbsp;&nbsp;&nbsp;(<%=seq%>)</td>
                <td align="right"> 
                              	
            	      <% if(auth_rw.equals("4")||auth_rw.equals("6")){%>
                        <%if(seq.equals(olaD.getAuction_maxSeq(car_mng_id))){//최근경매레코드일경우%>
            			          <%if(auction.getActn_cnt().equals("")){//경매회차없는경우%>
            		                <a href='javascript:updAuction("i");'><img src=../images/center/button_reg.gif align=absmiddle border=0></a> 
            			          <%}else{%>
            		                <a href='javascript:updAuction("u");'><img src=../images/center/button_modify.gif align=absmiddle border=0></a> 
					                      <%if(auction.getActn_st().equals("4") && auction.getNak_pr()==0){%>
					                          <a href='javascript:cngUAuction();'>[유찰로변경]</a> 
					                      <%}%>
            			          <%}%> 
                        <%}%>
            	      <% }%>	
                </td>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding='0' width="100%">
                <tr> 
                    <td class='title' rowspan="2" width=15%>경매정보</td>
                    <td class='title' width=17%>경매상태</td>
                    <td class='title' width=15%>경매회차</td>
                    <td class='title' width=17%>출품번호</td>
                    <td class='title' width=17%>경매일</td>
                    <td class='title' width=19%>유찰횟수</td>
                </tr>
                <tr> 
                    <td align="center"> 
                      <%if(seq.equals(olaD.getAuction_maxSeq(car_mng_id))){//최근경매레코드일경우%>
                      
                      <%	if(auction.getActn_st().equals("0")){//출품예정%>
                      <select name="actn_st">
                        <option value="0" <%if(auction.getActn_st().equals("0")){%>selected<%}%>>출품예정</option>
                        <option value="1" <%if(auction.getActn_st().equals("1")){%>selected<%}%>>경매진행중</option>
                      </select>
                      <%	}else if(auction.getActn_st().equals("1")||auction.getActn_st().equals("")){//경매진행중%>
                      <select name="actn_st" onChange="javascript:FootWin()">
                        <option value="1" <%if(auction.getActn_st().equals("1")){%>selected<%}%>>경매진행중</option>
                        <option value="2" <%if(auction.getActn_st().equals("2")){%>selected<%}%>>유찰</option>
                        <option value="3" <%if(auction.getActn_st().equals("3")){%>selected<%}%>>개별상담</option>
                        <option value="4" <%if(auction.getActn_st().equals("4")){%>selected<%}%>>낙찰</option>
                      </select>
                      <%	}else if(auction.getActn_st().equals("2")){//유찰%>
                      <select name="actn_st" onChange="javascript:FootWin()">
                        <option value="2" <%if(auction.getActn_st().equals("2")){%>selected<%}%>>유찰</option>
                      </select>
                      <%	}else if(auction.getActn_st().equals("3")){//개별상담%>
                      <select name="actn_st" onChange="javascript:FootWin()">
                        <option value="3" <%if(auction.getActn_st().equals("3")){%>selected<%}%>>개별상담</option>
                      </select>
                      <%	}else if(auction.getActn_st().equals("4")){//낙찰%>
                      <input type="hidden" name="actn_st" value="4">
                      낙찰 
		      <%	}%>
		      
		      <%}else{//지난경매레코드 즉 이력을 볼 경우%>
            	      <%	if(auction.getActn_st().equals("2")){//유찰일경우%>
                      <%		if(!per_id.equals("")){//개별상담내역이 존재하면%>
                      <input type="hidden" name="actn_st_h" value="3">
                      유찰(<a href="javascript:per_talk()">개별상담</a>) 
                      <%		}else{%>
                      <input type="hidden" name="actn_st_h" value="">
                      유찰 
                      <%		}%>
           	      <%	}else if(auction.getActn_st().equals("4")){//낙찰일경우%>
                      <input type="hidden" name="actn_st_h" value="4">
                      낙찰 
                      <%	}else{//그 외는 잘못된 경매상태%>
                      <input type="hidden" name="actn_st_h" value="">
                      이력검토 
                      <%	}%>
        	      <%}%>        	      
                    </td>
                    <td align="center"> 
                      <input class="text" type="text" name="actn_cnt" size="10" value="<%=auction.getActn_cnt()%>">
                      회 </td>
                    <td align="center"> 
                      <input class="text" type="text" name="actn_num" size="15" value="<%=auction.getActn_num()%>">
                    </td>
                    <td align="center"> 
                      <input class="text" type="text" name="actn_dt" size="15" value="<%=AddUtil.ChangeDate2(auction.getActn_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align="center"> 
                      <input class="white" type="text" name="seq_s" size="15" value="<%=AddUtil.parseInt(auction.getSeq())-1%>" readonly>
                    </td>
                </tr>
				
				<%if(nm_db.getWorkAuthUser("전산팀",user_id)||nm_db.getWorkAuthUser("경매처리",user_id)||nm_db.getWorkAuthUser("매각관리자",user_id)){%>				
				<tr>
					<td class='title'>출품수수료(원)</td>
					<td  align="center"> <input class="num" type="text" name="out_amt" size="15" value="<%=AddUtil.parseDecimal(auction.getOut_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
					<td class='title'>스캔</td>
					<td colspan='3' align="center">
					
					<input type="file" name="offls_file" value="<%=auction.getOffls_file()%>" size="50"></td>
				</tr>
				<%}%>
				
            </table>
        </td>
        <td width=20>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2" ><img src="/images/blank.gif" align="absmiddle" border="0"></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tR>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class='title' rowspan="2" width=15%>차량가격</td>
                    <td class='title' width=17%>기본차가(원)</td>
                    <td class='title' width=15%>시작가(원)</td>
                    <td class='title' width=17%>희망가(원)</td>
                    <td class='title' width=9%>신차대비(%)</td>
                    <td class='title' width=8%>전경매대비(%)</td>
                    <td class='title' width=19%>예상낙찰가(원)</td>
                </tr>
                <tr> 
                    <td  align="center"> 
                      <input class="num" type="text" name="car_pr" size="15" value="<%=AddUtil.parseDecimal(carpr)%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                    </td>
                    <td  align="center"> 
                      <input class="num" type="text" name="st_pr" size="15" value="<%=AddUtil.parseDecimal(auction.getSt_pr())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                    </td>
                    <td  align="center"> 
                      <input class="num" type="text" name="hp_pr" size="15" value="<%=AddUtil.parseDecimal(auction.getHp_pr())%>" onBlur='javascript:this.value=getHpprPer(this.value)'>
                    </td>
                    <td  align="center"> 
                      <input class="white" type="text" name="hp_pr_per" size="5" value="<%=AddUtil.parseDecimal(hp_pr_per)%>" readonly>
                    </td>
                    <td  align="center"><%=AddUtil.parseDecimal(pre_hp_per)%> 
                    </td>
                    <td  align="center">                       
                      <input class="num" type="text" name="o_s_amt" size="15" value="<%=AddUtil.parseDecimal(auction.getO_s_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                      <input type="button" class="button" value="계산" onclick="set_OsAmt()"/>                      
                      <input type="button" class="button" value="이력" onclick="set_OsAmt_h()"/>                      
                    </td>
                </tr>
				
            </table>
        </td>
        <td width=20>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2" height="7"><img src="/images/blank.gif" align="absmiddle" border="0"></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tR>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class='title' rowspan="2" width=15%>차량정보</td>
                    <td class='title' width=17%>차명</td>
                    <td class='title' width=15%>색상</td>
                    <td class='title' width=17%>주행거리</td>
                    <td class='title' width=17%>최초등록일</td>
                    <td class='title' width=19%>차령</td>
                </tr>
                <tr> 
                    <td  align="center"><%=olaBean.getCar_jnm()%>  <%=olaBean.getCar_nm()%></td>
                    <td  align="center"><%=AddUtil.subData(olaBean.getColo(),8)%></td>
                    <td  align="center"><%=AddUtil.parseDecimal(olaBean.getKm())%>km</td>
                    <td  align="center"><%=AddUtil.ChangeDate2(olaBean.getInit_reg_dt())%></td>
                    <td  align="center"><%=ht.get("YEAR")%>년 <%=ht.get("MONTH")%>개월</td>
                </tr>
            </table>
        </td>
        <td width=20>&nbsp;</td>
    </tr>
	<tr> 
        <td colspan="2" height="7"><img src="/images/blank.gif" align="absmiddle" border="0"></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tR>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0"  width="100%">
                <tr> 
                    <td class='title' rowspan="3" width=15%>차량상태</td>
                    <td class='title' width=17%>구분</td>
                    <td class='title' width=15%>점수</td>
                    <td class='title' width=34%>평가요인</td>
                    <td class='title' width=19%>평가자</td>
                </tr>
                <tr> 
                    <td class='title' align="center">아마존카(10점만점)</td>
                    <td  align="center"> 
                      <input class="text" type="text" name="ama_jum" size="15" value="<%=auction.getAma_jum()%>">
                    </td>
                    <td> &nbsp; 
                      <input class="text" type="text" name="ama_rsn" size="55" value="<%=auction.getAma_rsn()%>">
                    </td>
                    <td align="center"> &nbsp; 
                      <input class="text" type="text" name="ama_nm" size="15" value="<%=auction.getAma_nm()%>">
                    </td>
                </tr>
                <tr> 
                    <td class='title' align="center">경매장(10점만점)</td>
                    <td  align="center"> 
                      <input class="text" type="text" name="actn_jum" size="15" value="<%=auction.getActn_jum()%>">
                    </td>
                    <td> &nbsp; 
                      <input class="text" type="text" name="actn_rsn" size="55" value="<%=auction.getActn_rsn()%>">
                    </td>
                    <td align="center"> &nbsp; 
                      <input class="text" type="text" name="actn_nm" size="15" value="<%=auction.getActn_nm()%>">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
