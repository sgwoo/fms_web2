<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<jsp:useBean id="olaBean" class="acar.offls_actn.Offls_actnBean" scope="page"/>
<jsp:useBean id="auction_re" class="acar.offls_actn.Offls_auction_reBean" scope="page"/>
<jsp:useBean id="auction" class="acar.offls_actn.Offls_auctionBean" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"01":request.getParameter("seq");
	String actn_cnt = request.getParameter("actn_cnt")==null?"0":request.getParameter("actn_cnt");
	
	auction = olaD.getAuction(car_mng_id, seq);
	
	auction_re = olaD.getAuction_re(car_mng_id, actn_cnt);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP"); //사원전체리스트
	int user_size = users.size();
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//희망가,시작가 퍼센트
	olaBean = olaD.getActn_detail(car_mng_id);
	int carpr = olaBean.getCar_cs_amt()+olaBean.getCar_cv_amt()+olaBean.getOpt_cs_amt()+olaBean.getOpt_cv_amt()+olaBean.getClr_cs_amt()+olaBean.getClr_cv_amt();
	double hppr_per=0.0D, stpr_per=0.0D;
	double hppr = auction_re.getHp_pr();
	double stpr = auction_re.getSt_pr();
	if(carpr==0){
		hppr_per = 0;
		stpr_per = 0;
	}else{
		hppr_per = (hppr*100)/carpr;
		stpr_per = (stpr*100)/carpr;
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style>
a:link { text-decoration:none; }
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function auction_reUpd(ioru)
{
	var fm = document.form1;
	var re_dt = ChangeDate2(fm.re_dt.value);
	if(re_dt != ""){
		if(ioru=="i"){
			if(!confirm('등록 하시겠습니까?')){ return; }
		}else if(ioru=="u"){
			if(!confirm('수정 하시겠습니까?')){ return; }
		}
		fm.gubun.value = ioru;
		fm.action="/acar/off_ls_jh/off_ls_jh_actn_mng_re_upd.jsp";
		fm.target = "i_no";	
		fm.submit();		
	}else{
		alert('재출품일자를 입력하십시오.');
		return;
	}	
}
function auction_re(){
	var fm = document.form1;
	if(!confirm('재출품하시겠읍니까?')){ return; }
	fm.action = "/acar/off_ls_jh/off_ls_jh_actn_mng_re_chul.jsp";
	fm.target = "i_no";
	fm.submit();
}
function getHpprPer(){
	var fm = document.form1;
	var hp_pr = toInt(parseDigit(fm.hp_pr.value));
	var carpr = toInt(parseDigit(fm.carpr.value));
	var per = (hp_pr*100)/carpr;
	fm.hp_pr.value = parseDecimal2(hp_pr);
//	fm.hppr_per.value = getPonitLen(per,2);
	fm.hppr_per.value = parseFloatCipher3(per,2);
//	alert(per)
}
function getStprPer(){
	var fm = document.form1;
	var st_pr = toInt(parseDigit(fm.st_pr.value));
	var carpr = toInt(parseDigit(fm.carpr.value));
	var per = (st_pr*100)/carpr;
	fm.st_pr.value = parseDecimal2(st_pr);
//	fm.stpr_per.value = getPonitLen(per,2);
	fm.stpr_per.value = parseFloatCipher3(per,2);
//	alert(per)
}
//-->
</script>
</head>
<body>
<form name="form1" action="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="actn_cnt" value="<%=actn_cnt%>">
<input type="hidden" name="gubun" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td align='left'><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>재출품</span>	  
	  <%//if(auth_rw.equals("4")||auth_rw.equals("6")){%>
	  <%if(seq.equals(olaD.getAuction_maxSeq(car_mng_id)) && !auction_re.getCar_mng_id().equals("")){//최근경매레코드일경우%>
	  	<a href='javascript:auction_re();'><img src=../images/center/button_cp.gif border=0 align=absmiddle></a></td>
	  <%}%>
	  <%//}%>
        <td align='right'> 
        <%//if(auth_rw.equals("4")||auth_rw.equals("6")){%>
        <%if(seq.equals(olaD.getAuction_maxSeq(car_mng_id))){//최근경매레코드일경우%>
        <%if(auction_re.getCar_mng_id().equals("")){%>
        <a href='javascript:auction_reUpd("i");' onMouseOver="window.status=''; return true"> 
        <img src=../images/center/button_reg.gif align=absmiddle border=0></a> 
        <%}else{%>
        <a href='javascript:auction_reUpd("u");' onMouseOver="window.status=''; return true"> 
        <img src=../images/center/button_modify.gif align=absmiddle border=0></a> 
        <%}%>
        <%}%>
        <%//}%>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=25%>가격결정자</td>
                    <td class='title' width=25%>신차가</td>
                    <td class='title' width=25%>시작가(신차대비)</td>
                    <td class='title' width=25%>희망가(신차대비)</td>
                </tr>
                <tr> 
                    <td align="center"> 
                      <select name="damdang_id">
                        <option value='' <%if(auction_re.getDamdang_id().equals("")){%>selected<%}%>>선택</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	
        %>
                        <option value='<%=user.get("USER_ID")%>' <%if(auction_re.getDamdang_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%
        						}
        					}		%>
                      </select>
                    </td>
                    <td align="center"> 
                      <input  class="num" type="text" name="carpr" size="12" value="<%=AddUtil.parseDecimal(carpr)%>">
                      원 </td>
                    <td align="center"> 
                      <input  class="num" type="text" name="st_pr" size="12" value="<%=AddUtil.parseDecimal(auction_re.getSt_pr())%>" onChange="javascript:getStprPer()">
                      ( 
                      <input  class="white" type="text" name="stpr_per" size="5" value="<%=AddUtil.parseDecimal(stpr_per)%>" readonly>
                      %)</td>
                    <td align="center"> 
                      <input  class="num" type="text" name="hp_pr" size="12" value="<%=AddUtil.parseDecimal(auction_re.getHp_pr())%>" onChange="javascript:getHpprPer()">
                      ( 
                      <input  class="white" type="text" name="hppr_per" size="5" value="<%=AddUtil.parseDecimal(hppr_per)%>" readonly>
                      %)</td>
                </tr>
                <tr> 
                    <td class='title'>재출품일자</td>
                    <td class='title'>경매장담당자</td>
                    <td class='title'>전화번호</td>
                    <td class='title'>최종수정자</td>
                </tr>
                <tr> 
                    <td align="center">
        			<input class="text" type="text" name="re_dt" size="15" value="<%=AddUtil.ChangeDate2(auction_re.getRe_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align="center">
                      <input class="text" type="text" name="re_nm" size="15" value="<%=auction_re.getRe_nm()%>">
                    </td>
                    <td align="center">
                      <input class="text" type="text" name="re_tel" size="15" value="<%=auction_re.getRe_tel()%>">
                    </td>
                    <td align="center">
        			<%if(login.getAcarName(auction_re.getModify_id()).equals("error")){%>
                      &nbsp;
                      <%}else{%>
                      <%=login.getAcarName(auction_re.getModify_id())%> 
                      <%}%>
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
