<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.tint.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//납품관리
	TintBean tint 	= t_db.getTint(rent_mng_id, rent_l_cd);
	
	//일정관리
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
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
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
      <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>납품요청내역</span></span></td>
			<td class=bar align=right></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 	
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>계약번호</td>
            <td width=15%>&nbsp;<%=rent_l_cd%></td>
            <td class=title width=10%>상호</td>
            <td colspan="3">&nbsp;<%=client.getFirm_nm()%></td>
            <td class=title width=10%>차량구분</td>
            <td colspan="5">&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
		  </tr>	
          <tr> 
            <td class=title width=10%>제작사명</td>
            <td width=15%>&nbsp;<%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%></td>
            <td class=title width=10%>차명</td>
            <td colspan="3">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
            <td class=title width=10%>색상</td>
            <td width=15%>&nbsp;<%=car.getColo()%></td>
		  </tr>	
          <tr> 
            <td class=title width=10% style='height:36'>차대번호</td>
            <td width=15%>&nbsp;<%=pur.getCar_num()%></td>
            <td class=title width=10%>차량번호</td>
            <td width=15%>&nbsp;<%=cr_bean.getCar_no()%></td>
            <td class=title width=10%>임시운행<br>허가번호</td>
            <td width=15%>&nbsp;<%=pur.getTmp_drv_no()%></td>
            <td class=title width=10%>인수지</td>
            <td width=15%>&nbsp;<%if(pur.getUdt_st().equals("1")){%>본사<%}%><%if(pur.getUdt_st().equals("2")){%>지점<%}%><%if(pur.getUdt_st().equals("3")){%>고객<%}%></td>
		  </tr>
          <tr> 
            <td class=title width=10%>출고예정일시</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>&nbsp;<%=String.valueOf(est.get("DLV_EST_H"))%>시</td>
            <td class=title width=10%>인수예정일자</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(pur.getUdt_est_dt())%></td>
            <td class=title width=10%>등록예정일시</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("REG_EST_DT")))%>&nbsp;<%=String.valueOf(est.get("REG_EST_H"))%>시</td>
            <td class=title width=10%>납품에정일시</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("RENT_EST_DT")))%>&nbsp;<%=String.valueOf(est.get("RENT_EST_H"))%>시</td>
		  </tr>
		</table>
	  </td>
	</tr>
	<tr>
	    <td></td>
	</tr>	 	
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>납품요청내역</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td class=title>납품요청여부</td>
            <td colspan="3">&nbsp;
			  <input type='checkbox' name="tint_yn" value='Y' <%if(!tint.getTint_no().equals(""))%>checked<%%>>요청한다
			</td>
          </tr>		
          <tr> 
            <td colspan="2" class=title>썬팅</td>
            <td colspan="2" class=title>청소용품</td>
          </tr>
          <tr>
            <td width="10%" class=title>필름선택</td>
            <td width="40%" >&nbsp;
			  <input type='radio' name="film_st" value=''  <%if(tint.getFilm_st().equals(""))%>checked<%%>>
				없음
			  <input type='radio' name="film_st" value='1' <%if(tint.getFilm_st().equals("1"))%>checked<%%>>
				일반
			  <input type='radio' name="film_st" value='2' <%if(tint.getFilm_st().equals("2"))%>checked<%%> <%if(tint.getFilm_st().equals("") && car.getSun_per()>0)%>checked<%%>>
				3M
			  <input type='radio' name="film_st" value='3' <%if(tint.getFilm_st().equals("3"))%>checked<%%>>
				루마
			</td>
            <td width="10%" class=title>기본</td>
            <td width="40%">&nbsp;
			  <input type='radio' name="cleaner_st" value='1' <%if(tint.getCleaner_st().equals("1"))%>checked<%%>>
				있음
			  <input type='radio' name="cleaner_st" value='2' <%if(tint.getCleaner_st().equals("2"))%>checked<%%>>
				없음
            </td>
          </tr>
          <tr>
            <td class=title>가시광선투과율</td>
            <td>&nbsp;
			  <input type='text' name='sun_per' size='3' <%if(!tint.getTint_no().equals("")){%>value='<%=tint.getSun_per()%>'<%}else{%>value='<%=car.getSun_per()%>'<%}%> class='default' >%
			</td>
            <td class=title>추가</td>
            <td>&nbsp;
                <input type='text' name='cleaner_add' size='60' value='<%=tint.getCleaner_add()%>' class='default' >
            </td>
          </tr>
          <tr> 
            <td colspan="2" class=title>네비게이션</td>
            <td colspan="2" class=title>기타</td>
          </tr>
          <tr>
            <td width="10%" class=title>상품명</td>
            <td>&nbsp;
                <input type='text' name='navi_nm' size='60' value='<%=tint.getNavi_nm()%>' class='default' >
            </td>
            <td colspan="2" rowspan="2">&nbsp;
			  <textarea name="sup_other" cols="57" rows="2" class="default"><%=tint.getOther()%></textarea></td>
          </tr>
          <tr>
            <td class=title>(예상)가격</td>
            <td>&nbsp;
                <input type='text' name='navi_est_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getNavi_est_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                원 </td>
          </tr>
          <tr>
            <td class=title>적요</td>
            <td colspan="3">&nbsp;
			  <input type='text' name='sup_etc' size='141' value='<%=tint.getEtc()%>' class='default' >
			</td>
          </tr>
          <tr>
            <td class=title style='height:36'>작업마감<br>요청일시</td>
            <td>&nbsp;
			  <input type='text' size='12' name='sup_est_dt' maxlength='12' class='default' <%if(tint.getSup_est_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint.getSup_est_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
			  <input type='text' size='2' name='sup_est_h' class='default' value=<%if(tint.getSup_est_dt().length()==10){%>'<%=tint.getSup_est_dt().substring(8)%>'<%}%>>시
			</td>
            <td class=title>업체명</td>
            <td>&nbsp;
			  <select name='sup_off_id' class='default'>
                  <option value="">선택</option>
                  <option value="002849다옴방"       <%if(tint.getOff_id().equals("002849"))%>selected<%%>>다옴방</option>
				  <option value="002850유림카랜드"     <%if(tint.getOff_id().equals("002850"))%>selected<%%>>유림카랜드</option>
				  <option value="002851웰스킨천연가죽" <%if(tint.getOff_id().equals("002851"))%>selected<%%>>웰스킨천연가죽</option>
                </select></td>
          </tr>	
          <tr>
            <td class=title>요청자</td>
            <td colspan="3">&nbsp;
			  <%=c_db.getNameById(tint.getReg_id(),"USER")%>&nbsp;
			  <%=AddUtil.ChangeDate2(tint.getReg_dt())%>
			</td>
          </tr>				  
		</table>
	  </td>
	</tr> 				
  </table>
</form>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

