<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*, acar.offls_yb.*"%>
<%@ page import="java.text.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_actn.Offls_actnBean"/>
<jsp:useBean id="apprsl" scope="page" class="acar.offls_pre.Off_ls_pre_apprsl"/>
<jsp:useBean id="auction" scope="page" class="acar.offls_actn.Offls_auctionBean"/>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<jsp:useBean id="olaBean" class="acar.offls_actn.Offls_actnBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"01":request.getParameter("seq");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//경매장
	Vector actns = olpD.getActns();
	
	//상세정보
	apprsl = olpD.getPre_apprsl(car_mng_id);
	detail = olaD.getActn_detail(car_mng_id);
	auction = olaD.getAuction(car_mng_id, seq);
	olaBean = olaD.getActn_detail(car_mng_id);
	
	Hashtable carOld 	= c_db.getOld(detail.getInit_reg_dt(), auction.getActn_dt());//차량등록 경과기간(차령)
	
	//3개월이상사용자
	Vector his = olyD.getCarHis3MList(car_mng_id);
	int his_size = his.size();
	
	int carpr = olaBean.getCar_cs_amt()+olaBean.getCar_cv_amt()+olaBean.getOpt_cs_amt()+olaBean.getOpt_cv_amt()+olaBean.getClr_cs_amt()+olaBean.getClr_cv_amt();
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style>
a:link { text-decoration:none; }
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--

//-->
</script>
</head>
<body>
<form name="form1" action="">
  <table border=0 cellspacing=0 cellpadding=0 width=100%>    
    <tr> 
      <td align='left' valign=middle><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>중고차 매각 현황</span></td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		  <!--출품구분-->
          <tr> 
            <td align="center">
              <%for(int i=0; i<actns.size(); i++){
        			Hashtable ht = (Hashtable)actns.elementAt(i);%>
              <%	if(ht.get("CLIENT_ID").equals(apprsl.getActn_id())){%><%=ht.get("FIRM_NM")%><%}%>
              <%}%>
            </td>
          </tr>
          <tr>
            <td align="center"><%=AddUtil.ChangeDate2(auction.getActn_dt())%></td>
          </tr>          
          <tr>
            <td align="center"><%=detail.getCar_jnm()+" "+detail.getCar_nm()%></td>
          </tr>
          <tr>
            <td align="center"><%=detail.getCar_y_form()%></td>
          </tr>          
          <tr>
            <td align="center"><%=AddUtil.ChangeDate2(detail.getInit_reg_dt())%></td>
          </tr>          
          <tr>
            <td align="center"><%=String.valueOf(carOld.get("YEAR"))%>년</td>
          </tr>          
          <tr>
            <td align="center"><%=String.valueOf(carOld.get("MONTH"))%>개월</td>
          </tr>          
          <tr>
            <td align="center"><%=detail.getCar_no()%></td>
          </tr>          
          <tr>
            <td align="center">&nbsp;</td>
          </tr>          
          <tr>
            <td align="center"><%=AddUtil.ChangeDate2(auction.getActn_dt())%></td>
          </tr>          
          <tr>
            <td align="center">
              <%=c_db.getNameByIdCode("0039", "", detail.getFuel_kd())%>
			  </td>
          </tr>          
          <tr>
            <td align="center">
			  <%if(his_size>0){%>
			  <%for(int i = 0 ; i < 1 ; i++){
    				CarHisBean ch = (CarHisBean)his.elementAt(i);%>
			  <%=ch.getFirm_nm()%>	
			  <%}}%>		
			</td>
          </tr>          
          <tr>
            <td align="center"><%=AddUtil.ChangeDate2(auction.getActn_dt())%></td>
          </tr>          
          <tr>
            <td align="center">
              <!--<%if(auction.getActn_st().equals("1")){%>경매진행중<%}%>-->
              <%if(auction.getActn_st().equals("2")){%>유찰<%}%>
              <!--<%if(auction.getActn_st().equals("3")){%>개별상담<%}%>-->
              <%if(auction.getActn_st().equals("4")){%>낙찰<%}%>
            </td>
          </tr>          
          <tr>
            <td align="center"><%=auction.getActn_num()%></td>
          </tr>          
          <tr>
            <td align="center"><%=AddUtil.parseDecimal(apprsl.getKm())%> km</td>
          </tr>          
          <tr>
            <td align="center">
			  <%if(apprsl.getSago_yn().equals("Y")){%>유<%}%>
			  <%if(apprsl.getSago_yn().equals("N")){%>무<%}%>
			</td>
          </tr>          
          <tr>
            <td align="center">&nbsp;</td>
          </tr>          
          <tr>
            <td align="center">양호</td>
          </tr>          
          <tr>
            <td align="center"><%=auction.getAma_jum()%><%if(auction.getAma_jum().equals("")){%>7.0<%}%>점</td>
          </tr>          
          <tr>
            <td align="center"><%=auction.getAma_jum()%><%if(auction.getAma_jum().equals("")){%>7.0<%}%>점</td>
          </tr>          
          <tr>
            <td align="center"><%=auction.getActn_jum()%><%if(auction.getActn_jum().equals("")){%>7<%}%>점</td>
          </tr>          
          <tr>
            <td align="center"><%=AddUtil.trunc_num(detail.getCar_cs_amt()+detail.getCar_cv_amt(), 4)%></td>
          </tr>          
          <tr>
            <td align="center"><%=AddUtil.trunc_num(detail.getOpt_cs_amt()+detail.getOpt_cv_amt(), 4)%></td>
          </tr>          
          <tr>
            <td align="center"><%=detail.getOpt()%></td>
          </tr>          
          <tr>
            <td align="center"><%=detail.getColo()%></td>
          </tr>          
          <tr>
            <td align="center"><%=AddUtil.trunc_num(detail.getCar_cs_amt()+detail.getCar_cv_amt()+detail.getOpt_cs_amt()+detail.getOpt_cv_amt(), 4)%></td>
          </tr>          		  
        </table>
      </td>
    </tr>
    <tr>
        <td align='right'><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>