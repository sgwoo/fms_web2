<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.out_car.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_register.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String car_off_id 	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String base_dt = request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	int serial 		= request.getParameter("serial")==null?0:AddUtil.parseInt(request.getParameter("serial"));
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "/fms2/car_cash_back/car_cash_back_frame.jsp");
	
	OutStatBean bean = oc_db.getCarCashBackBase(serial);
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(bean.getRent_mng_id(), bean.getRent_l_cd());
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//수정
	function Save(){
		var fm = document.form1;
		
		var ment = "수정하시겠습니까?";
		
		if(fm.reg_type[1].checked == true){
			ment = "카드사용 취소하시겠습니까?";
		}
		
		if(confirm(ment)){
			fm.action='car_cash_back_day_ui_a.jsp';
			//fm.target='i_no';
			fm.submit();
		}
	}
		
	function Close(){
		window.close();
	}
	

//-->
</script>

</head>
<body topmargin="10">
<form action="" name="form1" method="POST">
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='base_dt' value='<%=base_dt%>'>
<input type='hidden' name='car_off_id' value='<%=car_off_id%>'>
<input type='hidden' name='serial' value='<%=serial%>'>

  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>경영정보 > 재무회계 > <span class=style5>Cash 사용 수정 </span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>  
	<tr><td class=line2></td></tr>  
    <tr>
        <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
              <td width='20%'  class='title'>영업소</td>
              <td colspan='3'>&nbsp;<%=c_db.getNameById(car_off_id,"CAR_OFF")%></td>
            </tr>
            <tr>
              <td width='20%'  class='title'>고객</td>
              <td width='30%' >&nbsp;<%=client.getFirm_nm()%></td>
              <td width='20%'  class='title'>차종</td>
              <td width='30%' >&nbsp;<%=cr_bean.getCar_nm()%></td>
            </tr>
            <tr>
              <td width='20%'  class='title'>차량</td>
              <td>&nbsp;<%=cr_bean.getCar_no()%></td>
              <td width='20%'  class='title'>차대번호</td>
              <td>&nbsp;<%=cr_bean.getCar_num()%></td>
            </tr>
            <tr>
              <td width='20%'  class='title'>출고일자</td>
              <td>&nbsp;<%=AddUtil.ChangeDate2(base.getDlv_dt())%></td>
              <td width='20%'  class='title'>등록일자</td>
              <td>&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
            </tr>
		    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>* <%=serial%></td>
    </tr>
    <tr><td class=line2></td></tr> 	
    <tr>
        <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
              <td width='20%' class='title'>출고일자</td>
              <td>&nbsp;<%=AddUtil.ChangeDate2(bean.getBase_dt())%></td>
            </tr>
            <tr>
              <td class='title'>내용</td>
              <td>&nbsp;<%=bean.getBase_bigo()%></td>
            </tr>         
            <tr>
              <td width='20%' class='title'>입금예정일</td>
              <td>&nbsp;<%=AddUtil.ChangeDate2(bean.getEst_dt())%></td>
            </tr>
            <tr>
              <td class='title'>사용금액</td>
              <td>&nbsp;<input type="text" name="base_amt" size="10" value="<%=AddUtil.parseDecimalLong(bean.getBase_amt())%>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>원</td>
            </tr>         
            <tr>
              <td width='20%' class='title'>입금일자</td>
              <td>&nbsp;<%=AddUtil.ChangeDate2(bean.getIncom_dt())%></td>
            </tr>
            <tr>
              <td class='title'>입금금액</td>
              <td>&nbsp;<input type="text" name="incom_amt" size="10" value="<%=AddUtil.parseDecimalLong(bean.getIncom_amt())%>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>원</td>
            </tr>         
            <tr>
              <td class='title'>변경구분</td>
              <td>&nbsp;
                    <input type='radio' name="reg_type" value='U' checked>
        				  수정
        	        <input type='radio' name="reg_type" value='C'>
        				  취소        				  
              </td>
            </tr>            
          </table></td>
  </tr>
  <tr><td class=h></td></tr>  
    <tr> 
      <td align="right">
        <%if( auth_rw.equals("6")) {%>
        <a href="javascript:Save();"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
        &nbsp;
        <%}%>
	      <a href="javascript:Close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
      </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
