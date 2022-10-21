<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<jsp:useBean id="auction_ban" class="acar.offls_actn.Offls_auction_banBean" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"01":request.getParameter("seq");
	String actn_cnt = request.getParameter("actn_cnt")==null?"":request.getParameter("actn_cnt");

	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP"); //사원전체리스트
	int user_size = users.size();
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	auction_ban = olaD.getAuction_ban(car_mng_id, actn_cnt);
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
function auction_banUpd(ioru)
{
	var fm = document.form1;
	var ban_dt = ChangeDate2(fm.ban_dt.value);
	var js_dt = ChangeDate2(fm.js_dt.value);
	if(ban_dt != "" && js_dt != ""){
		if(ioru=="i"){
			if(!confirm('등록 하시겠습니까?')){ return; }
		}else if(ioru=="u"){
			if(!confirm('수정 하시겠습니까?')){ return; }
		}
		fm.gubun.value = ioru;
		fm.action="off_ls_jh_actn_mng_ban_upd.jsp";
		fm.target = "i_no";	
		fm.submit();	
	}else{
		if(ban_dt=="") alert("반출일자를 입력해 주세요!");
		if(js_dt=="") alert("입금일자를 입력해 주세요!");
		return;
	}	
}
function auction_ban(){
	var fm = document.form1;
	if(!confirm('반출하시겠읍니까?')){ return; }
	fm.action = "/acar/off_ls_jh/off_ls_jh_actn_mng_ban_chul.jsp";
	fm.target = "i_no";
	//fm.target = "_blank";
	fm.submit();
}
-->
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
        <td align='left' valign=middle><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>반출</span>&nbsp;
            <select name='ban_chk'>
                <option value=''>선택</option>
                <option value='N' <%if(olaD.getBan_chk(car_mng_id,actn_cnt).equals("N")){%>selected<%}%>>반출진행중</option>
                <option value='Y' <%if(olaD.getBan_chk(car_mng_id,actn_cnt).equals("Y")){%>selected<%}%>>반출완료</option>
            </select>&nbsp;            
		        <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
		            <%if(seq.equals(olaD.getAuction_maxSeq(car_mng_id)) && olaD.getBan_chk(car_mng_id,actn_cnt).equals("Y")){//최근경매레코드일경우%>
	  	              <a href="javascript:auction_ban()"><img src=../images/center/button_bc.gif border=0 align=absmiddle>
	              <%}%>
	          <%}%>
        </td>
        <td align='right'> 
        <%if(auth_rw.equals("4")||auth_rw.equals("6")){%>
		<%if(seq.equals(olaD.getAuction_maxSeq(car_mng_id))){//최근경매레코드일경우%>
			<%if(auction_ban.getCar_mng_id().equals("")){%>
		        <a href='javascript:auction_banUpd("i");'><img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
			<%}else{%>
		        <a href='javascript:auction_banUpd("u");'><img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
			<%}%>
		<%}%>
        <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=15%> 반출담당자</td>
                    <td width=17%> &nbsp; 
                      <input  class="text" type="text" name="ban_nm" size="12" value="<%=auction_ban.getBan_nm()%>">
                      &nbsp; </td>
                    <td class='title' width=17%>반출담당자 연락처</td>
                    <td width=17%> &nbsp; 
                      <input  class="text" type="text" name="ban_tel" size="12" value="<%=auction_ban.getBan_tel()%>">
                      &nbsp; &nbsp;&nbsp;</td>
                    <td class='title' width=17%>반출일자</td>
                    <td width=17%> &nbsp; 
                      <input  class="text" type="text" name="ban_dt" size="12" value="<%=AddUtil.ChangeDate2(auction_ban.getBan_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>탁송업체</td>
                    <td>&nbsp; 
                      <input  class="text" type="text" name="tak_up" size="12" value="<%=auction_ban.getTak_up()%>">
                    </td>
                    <td class='title'>탁송자</td>
                    <td>&nbsp; 
                      <input  class="text" type="text" name="tak_nm" size="12" value="<%=auction_ban.getTak_nm()%>">
                    </td>
                    <td class='title'>탁송자 연락처</td>
                    <td>&nbsp; 
                      <input  class="text" type="text" name="tak_tel" size="12" value="<%=auction_ban.getTak_tel()%>">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>출품수수료</td>
                    <td>&nbsp; 
                      <input  class="num" type="text" name="js_chul" size="12" value="<%=AddUtil.parseDecimal(auction_ban.getJs_chul())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                    </td>
                    <td class='title'>반출탁송료</td>
                    <td>&nbsp; 
                      <input  class="num" type="text" name="js_tak" size="12" value="<%=AddUtil.parseDecimal(auction_ban.getJs_tak())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                    </td>
                    <td class='title'>인수자</td>
                    <td>&nbsp; 
                      <select name="insu_id">
                        <option value='' <%if(auction_ban.getInsu_id().equals("")){%>selected<%}%>>선택</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	
        %>
                        <option value='<%=user.get("USER_ID")%>' <%if(auction_ban.getInsu_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%
        						}
        					}		%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>경매장입금액</td>
                    <td>&nbsp; 
                      <input  class="num" type="text" name="js_in_amt" size="12" value="<%=AddUtil.parseDecimal(auction_ban.getJs_in_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                    </td>
                    <td class='title'>입금일자</td>
                    <td>&nbsp; 
                      <input  class="text" type="text" name="js_dt" size="12" value="<%=AddUtil.ChangeDate2(auction_ban.getJs_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class='title'>최종수정자</td>
                    <td>&nbsp; 
        			<%if(login.getAcarName(auction_ban.getModify_id()).equals("error")){%>
                      &nbsp;
                      <%}else{%>
                      <%=login.getAcarName(auction_ban.getModify_id())%> 
                      <%}%></td>
                </tr>
		        <tr> 
                    <td class='title'>차량상태</td>
                    <td colspan="5">&nbsp; 
                      <input  class="text" type="text" name="ban_car_st" size="70" value="<%=auction_ban.getBan_car_st()%>">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>반출사유</td>
                    <td colspan="5">&nbsp; 
                      <textarea  class="textarea" name="ban_reason" cols="70" rows="2"><%=auction_ban.getBan_reason()%></textarea>
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