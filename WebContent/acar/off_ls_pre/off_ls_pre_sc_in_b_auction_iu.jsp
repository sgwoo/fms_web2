<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<%@ page import="java.text.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_pre.Offls_preBean"/>
<jsp:useBean id="auction" scope="page" class="acar.offls_actn.Offls_auctionBean"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	detail = olpD.getPre_detail(car_mng_id);
	auction = olaD.getAuction(car_mng_id, olaD.getAuction_maxSeq(car_mng_id));
	
	//사원전체리스트
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	//상품가격 수정 등록 구분하기 위해
	String auction_car_mng_id = olaD.getAuction_Car_mng_id(car_mng_id);
	
	//희망가,시작가 퍼센트
	int carpr = detail.getCar_cs_amt()+detail.getCar_cv_amt()+detail.getOpt_cs_amt()+detail.getOpt_cv_amt()+detail.getClr_cs_amt()+detail.getClr_cv_amt();
	float hppr_per=0.0f, stpr_per=0.0f;
	float hppr = auction.getHp_pr();
	float stpr = auction.getSt_pr();
	if(carpr==0){
		hppr_per = 0;
		stpr_per = 0;
	}else{
		hppr_per = (hppr*100)/carpr;
		stpr_per = (stpr*100)/carpr;
	}
	
	//반출시
	if(!olpD.getCar_mng_id_ban(car_mng_id).equals("")){
		detail.setDeterm_id("");
		detail.setHppr(0);
		detail.setStpr(0);
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function auctionUpd(ioru){
	var fm = document.form1;
	if(fm.determ_id.value==""){ alert('가격결장자를 선택해 주세요!'); return; }
	else if(fm.stpr.value==0){ alert('시작가를 입력해 주세요!'); return; }
	else if(fm.hppr.value==0){ alert('희망가를 입력해 주세요!'); return; }
	if(ioru=="i"){
		if(!confirm('등록하시겠습니까?')){ return; }
	}else if(ioru=="u"){
		if(!confirm('수정하시겠습니까?')){ return; }
	}
	fm.gubun.value = ioru;
	fm.action="/acar/off_ls_pre/off_ls_pre_auction_upd.jsp";
	fm.target = "i_no";	
	fm.submit();
}
function getHpprPer(){
	var fm = document.form1;
	var hppr = toInt(parseDigit(fm.hppr.value));
	var carpr = toInt(parseDigit(fm.carpr.value));
	var per = (hppr*100)/carpr;
	fm.hppr.value = parseDecimal(toInt(parseDigit(fm.hppr.value)));
	fm.hppr_per.value = parseFloatCipher3(per,2);
}
function getStprPer(){
	var fm = document.form1;
	var stpr = toInt(parseDigit(fm.stpr.value));
	var carpr = toInt(parseDigit(fm.carpr.value));
	var per = (stpr*100)/carpr;
	fm.stpr.value = parseDecimal(stpr);
	fm.stpr_per.value = parseFloatCipher3(per,2);	
}
-->
</script>
</head>

<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>상품가격결정</span></td>
          <td align="right"> 
            <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
          <%if(auction.getDamdang_id().equals("") && auction.getSt_pr()==0 && auction.getHp_pr()==0){%>
          <a href='javascript:auctionUpd("i");' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg_new.gif align=absmiddle border=0></a>&nbsp; 
          <%}else{%>
    	  <a href='javascript:auctionUpd("i");' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg_bg.gif align=absmiddle border=0></a>&nbsp;
          <a href='javascript:auctionUpd("u");' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_ggjj.gif align=absmiddle border=0></a> 
          <%}%>
          <%}%>
            <a href='javascript:history.go(-1);' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_back_p.gif align=absmiddle border=0></a> 
          </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width=16%>최종결정자</td>
                  <td class='title' width=28%>신차가</td>
                  <td class='title' width=28%>시작가(신차대비)</td>
                  <td class='title' width=28%>희망가(신차대비)</td>
                </tr>
                <tr> 
                  <td align="center"> <select name="determ_id">
                      <option value='' <%if(auction.getDamdang_id().equals("")){%>selected<%}%>>선택</option>
                      <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	
        %>
                      <option value='<%=user.get("USER_ID")%>' <%if(auction.getDamdang_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                      <%
        						}
        					}		%>
                    </select> </td>
                  <td align="center"> <input  class="num" type="text" name="carpr" size="12" value="<%=AddUtil.parseDecimal(carpr)%>">
                    원 </td>
                  <td align="center"> <input  class="num" type="text" name="stpr" size="12" value="<%=AddUtil.parseDecimal(auction.getSt_pr())%>" onBlur="javascript:getStprPer()">
                    ( 
                    <input  class="white" type="text" name="stpr_per" size="5" value="<%=AddUtil.parseFloatCipher2(stpr_per,2)%>" >
                    %)</td>
                  <td align="center"> <input  class="num" type="text" name="hppr" size="12" value="<%=AddUtil.parseDecimal(auction.getHp_pr())%>" onBlur="javascript:getHpprPer()">
                    ( 
                    <input  class="white" type="text" name="hppr_per" size="5" value="<%=AddUtil.parseFloatCipher2(hppr_per,2)%>">
                    %)</td>
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
