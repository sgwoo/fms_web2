<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.client.*, acar.car_mst.*, acar.car_register.*, acar.user_mng.*, acar.car_office.*"%>
<%@ page import="acar.tint.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

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
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	co_bean = cod.getCarOffBean(emp2.getCar_off_id());
	
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
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean 	= umd.getUsersBean(base.getBus_id());
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_p.css"></link>
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
  <table width="500" border="0" cellspacing="0" cellpadding="0">	
    <tr>
	  <td class=line>
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
		  <tr>
		    <td colspan="7">
			  <table border="0" cellspacing="0" cellpadding='0' width=100%>
			    <tr>
				  <td><font color="#FF0000"><img src="/acar/images/logo_1.png" border="0"></font></td>
				</tr>
			    <tr>
				  <td align="center" style="font-size:14pt">문&nbsp;서&nbsp;처&nbsp;리&nbsp;전</td>
				</tr>
			    <tr>
			      <td align="center"></td>
		        </tr>
			  </table>
			</td>
	      </tr>
		  <tr>
		    <td colspan="2" align="center" class="h30">수신처</td>
		    <td colspan="2" align="center">총무팀</td>
		    <td align="center">수신일자</td>
		    <td colspan="2" align="center"><input type='text' size='11' name='dt1' maxlength='12' class='whitetext' value='<%if(!pur.getCon_pay_dt().equals("")){%><%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%><%}else{%><%=AddUtil.getDate3()%><%}%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
	      </tr>
		  <tr>
		    <td colspan="2" align="center" class="h30">발신처</td>
		    <td colspan="2" align="center"><%if(user_bean.getBr_id().equals("S1")){%>총무팀<%}else{%><%=user_bean.getDept_nm()%><%}%></td>
		    <td align="center" class="h30">발신일자</td>
		    <td colspan="2" align="center"><input type='text' size='11' name='dt2' maxlength='12' class='whitetext' value='<%if(!pur.getCon_pay_dt().equals("")){%><%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%><%}else{%><%=AddUtil.getDate3()%><%}%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
	      </tr>
		  <tr>
		    <td colspan="2" align="center" class="h30">제목</td>
		    <td colspan="5">&nbsp;자동차 구입자금 지출 결의 - 차량계약금</td>
	      </tr>
		  <tr>
		    <td colspan="7">
			  <table border="0" cellspacing="0" cellpadding='0' width=100%>
			    <tr>
				  <td width="100" align="center">내용</td>
				  <td>&nbsp;</td>				  
				</tr>
			    <tr>
				  <td>&nbsp;</td>
				  <td>1. 아래와 같이 자동차 구입자금의 지출을 요청하오니 결재바랍니다.</td>				  
				</tr>
			    <tr>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>				  
		        </tr>
			    <tr>
				  <td colspan="2" align="center">< 아&nbsp;&nbsp;&nbsp;&nbsp;래 ></td>
		        </tr>
			  </table>
			</td>
	      </tr>
		  <tr>
		    <td colspan="2" align="center" class="h30">계약번호</td>
		    <td colspan="2" align="center"><%=base.getRent_l_cd()%></td>
		    <td align="center">계약자</td>
		    <td colspan="2" align="center"><%=client.getFirm_nm()%></td>
	      </tr>
		  <tr>
		    <td colspan="2" align="center" class="h30">게약차종</td>
		    <td colspan="2" align="center"><%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
		    <td align="center">매입구분</td>
		    <td colspan="2" align="center"><%String purc_gu = car.getPurc_gu();%>
                <%if(purc_gu.equals("1")){%>
                과세
                <%}else if(purc_gu.equals("0")){%>
                면세
                <%}%></td>
	      </tr>
		  <tr>
		    <td colspan="2" align="center" class="h30">지출일</td>
		    <td colspan="2" align="center"><input type='text' size='11' name='con_pay_dt' maxlength='12' class='whitetext_ce' value='<%=AddUtil.getDate()%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
		    <td align="center">지출금액</td>
		    <td colspan="2" align="center"><input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='whitenum' size='8' onBlur='javascript:this.value=parseDecimal(this.value);'>
            원</td>
	      </tr>
		  <tr>
		    <td colspan="2" align="center" class="h30">지급처</td>
		    <td colspan="2" align="center"><%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%>&nbsp;<%=emp2.getCar_off_nm()%></td>
		    <td align="center">담당자</td>
		    <td colspan="2" align="center"><%=user_bean.getUser_nm()%></td>
	      </tr>
		  <%	if(!pur.getCon_bank().equals("")){
		  			co_bean.setBank		(pur.getCon_bank());
		  			co_bean.setAcc_no	(pur.getCon_acc_no());
		  		}
		  %>
		  <tr>		  
		    <td colspan="2" align="center" class="h30">은행</td>
		    <td colspan="2" align="center"><input type='text' size='20' name='bank' maxlength='50' class='whitetext_ce' value='<%=co_bean.getBank()%>'></td>
		    <td align="center">계좌번호</td>
		    <td colspan="2" align="center"><input type='text' size='25' name='acc_no' maxlength='50' class='whitetext_ce' value='<%=co_bean.getAcc_no()%>'></td>
	      </tr>
		  <tr>
		    <td colspan="7">
			  <table border="0" cellspacing="0" cellpadding='0' width=100%>
			    <tr>
				  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;처리의견 및 지시사항</td>
				</tr>
			    <tr>
				  <td>&nbsp;</td>				  
		        </tr>
			    <tr>
				  <td>&nbsp;</td>				  
		        </tr>
			    <tr>
				  <td>&nbsp;</td>				  
		        </tr>
			    <tr>
				  <td>&nbsp;</td>				  
		        </tr>
			    <tr>
				  <td align="right">
				  	<%if(!pur.getCon_pay_dt().equals("")){%>	
				  	<%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%>
				  	<%}else{%>
				  	<%=AddUtil.getDate3()%>
				  	<%}%>
				  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
			  </table>
			</td>
	      </tr>
		  <%if(user_bean.getBr_id().equals("S1")||user_bean.getBr_id().equals("S2")||user_bean.getBr_id().equals("I1")||user_bean.getBr_id().equals("K3")||user_bean.getBr_id().equals("S3")||user_bean.getBr_id().equals("S4")||user_bean.getBr_id().equals("S5")||user_bean.getBr_id().equals("S6")){%>
		  <tr>
		    <td width="20" rowspan="2" align="center">&nbsp;<br>결<br>&nbsp;<br>재<br>&nbsp;</td>
		    <td width="80" align="center">담당</td>
		    <td width="80" align="center">차장</td>
		    <td width="80" align="center">부장</td>
		    <td width="80"></td>
		    <td width="80"></td>			
		    <td width="80"></td>
	      </tr>
		  <%}else{%>
		  <tr>
		    <td width="20" rowspan="2" align="center">&nbsp;<br>결<br>&nbsp;<br>재<br>&nbsp;</td>
		    <td width="80" align="center">담당</td>
		    <td width="80" align="center">지점장</td>
		    <td width="80" align="center">차장</td>
		    <td width="80" align="center">부장</td>
		    <td width="80"></td>
		    <td width="80"></td>
	      </tr>
		  <%}%>
		  <tr>
		    <td align="center"><%=c_db.getNameById(base.getBus_id(),"USER_PO")%><br>
	        	<%if(!pur.getCon_pay_dt().equals("")){%>	
				  	<%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%>
				  	<%}else{%>
				  	<%=AddUtil.getDate3()%>
				  	<%}%></td>
	        <td width="80" align="center">&nbsp;</td>
		    <td width="80" align="center">&nbsp;</td>
		    <td width="80" align="center">&nbsp;</td>
		    <td width="80"></td>
		    <td width="80">&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;</td>
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

