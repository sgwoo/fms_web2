<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.* "%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//영업,출고사원
	Hashtable mgrs = a_db.getCommiNInfo(rent_mng_id, rent_l_cd);
	Hashtable mgr_bus = (Hashtable)mgrs.get("BUS");
	Hashtable mgr_dlv = (Hashtable)mgrs.get("DLV");
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	CarChaBean cha1 = crd.getCarCha(base.getCar_mng_id(),"1");
	CarChaBean cha2 = crd.getCarCha(base.getCar_mng_id(),"2");
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//할부정보
	ContDebtBean debt = a_db.getContDebt(rent_mng_id, rent_l_cd);
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//해당대여정보
	ContFeeBean fee 	= a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	//첫대여정보
	ContFeeBean f_fee 	= a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//마지막대여정보
	ContFeeBean l_fee 	= a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	
	//해지정보
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<table border=0 cellspacing=0 cellpadding=0 width=1000>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td colspan="2" class=title style="font-size : 8pt;">계약번호</td>
                    <td class=title width=10% style="font-size : 8pt;">차량번호</td>
                    <td width="10%" colspan="4" rowspan="2" align="center" style="font-size : 15pt;">계약봉투</td>
                    <td class=title width=10% style="font-size : 8pt;">관리번호</td>
                    <td class=title width=10% style="font-size : 8pt;">관리자</td>
                    <td class=title width=10% style="font-size : 8pt;">관리책임자</td>
                </tr>
                <tr>
                  <td colspan="2" align="center"><%=rent_l_cd%></td>
                  <td width=10% align="center"><b><font color='#990000'><%=cr_bean.getCar_no()%></font></b></td>
                  <td align="center"><%=cr_bean.getCar_doc_no()%></td>
                  <td align="center"><%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                  <td align="center"><%=c_db.getNameById(fee_etc.getChk_id(),"USER")%></td>
                </tr>
                <tr>
                  <td width="10%" rowspan="2" class=title style="font-size : 8pt;">계약자</td>
                  <td width="10%" rowspan="2" align="center"><b><font color='#990000'><%=client.getFirm_nm()%></font></b></td>
                  <td colspan="4" class=title style="font-size : 8pt;">계약조건</td>
                  <td colspan="4" class=title style="font-size : 8pt;">구매조건</td>
                </tr>
                <tr>
                  <td width="10%" class=title style="font-size : 8pt;">대여구분</td>
                  <td width="10%" class=title style="font-size : 8pt;">대여유형</td>
                  <td width="10%" class=title style="font-size : 8pt;">등록지역</td>
                  <td width="10%" class=title style="font-size : 8pt;">보험가입연령</td>
                  <td width="10%" class=title style="font-size : 8pt;">금융사명</td>
                  <td width="10%" class=title style="font-size : 8pt;">할부조건</td>
                  <td width="10%" class=title style="font-size : 8pt;">할부유형</td>
                  <td width="10%" class=title style="font-size : 8pt;">변경일자</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">차명</td>
                  <td align="center"><%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                  <td align="center"><%String car_st = base.getCar_st();%>
                    <%if(car_st.equals("1")){%>
                    렌트
                    <%}else if(car_st.equals("2")){%>
                    예비
                    <%}else if(car_st.equals("3")){%>
                    리스
                  <%}%></td>
                  <td align="center"><%String rent_way = fee.getRent_way();%>
                    <%if(rent_way.equals("1")){%>
                    일반식
                    <%}else if(rent_way.equals("3")){%>
                    기본식
                  <%}%></td>
                  <td align="center"><%String car_ext = car.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%></td>
                  <td align="center"><%String driving_age = base.getDriving_age();%>
                  <%if(driving_age.equals("0")){%>26세이상<%}
                  else if(driving_age.equals("3")){%>24세이상<%}
                  else if(driving_age.equals("1")){%>21세이상<%}
                  else if(driving_age.equals("2")){%>모든운전자<%}
                  else if(driving_age.equals("5")){%>30세이상<%}
                  else if(driving_age.equals("6")){%>35세이상<%}
                  else if(driving_age.equals("7")){%>43세이상<%}
                  else if(driving_age.equals("8")){%>48세이상<%}
                  else if(driving_age.equals("9")){%>22세이상<%}
                  else if(driving_age.equals("10")){%>28세이상<%}
                  else if(driving_age.equals("11")){%>35세이상~49세이하<%}%>
                  </td>
                  <td align="center"><%=c_db.getNameById(debt.getCpt_cd(), "BANK")%></td>
                  <td align="center"><%if(!debt.getCpt_cd().equals("")){%><%=AddUtil.parseDecimal(debt.getLend_prn())%>원<br>/ <%=debt.getTot_alt_tm()%>개월<%}%></td>
                  <td align="center"><%if(!debt.getCpt_cd().equals("")){%><%if(debt.getLend_id().equals("")){%>개별<%}else{%>묶음<%}%><%}%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(debt.getLend_dt())%></td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">계약일자</td>
                  <td align="center"><%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">출고일자</td>
                  <td align="center"><%=AddUtil.ChangeDate2(base.getDlv_dt())%></td>
                  <td colspan="4" class=title style="font-size : 8pt;">채권서류</td>
                  <td colspan="4" class=title style="font-size : 8pt;">자동차근저당설정</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">등록일자</td>
				  <td align="center"><%=cr_bean.getInit_reg_dt()%></td>
                  <td class=title style="font-size : 8pt;">구분</td>                  
                  <td class=title style="font-size : 8pt;">완결일자</td>
                  <td class=title style="font-size : 8pt;">확인자</td>
                  <td class=title style="font-size : 8pt;">비고</td>
                  <td class=title style="font-size : 8pt;">저당권자</td>
                  <td class=title style="font-size : 8pt;">채권가액</td>
                  <td class=title style="font-size : 8pt;">설정일자</td>
                  <td class=title style="font-size : 8pt;">해지일자</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">인도일자</td>
                  <td align="center"><%=AddUtil.ChangeDate2(f_fee.getRent_start_dt())%></td>
                  <td class=title style="font-size : 8pt;">연대보증서</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">계약기간</td>
                  <td align="center">&nbsp;<%=fee.getCon_mon()%>개월</td>
                  <td class=title style="font-size : 8pt;">공정증서</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">계약개시일</td>
                  <td align="center"><%=AddUtil.ChangeDate2(f_fee.getRent_start_dt())%></td>
                  <td class=title style="font-size : 8pt;">보증보험증권</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                  <td align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">계약만료일</td>
                  <td align="center"><%=AddUtil.ChangeDate2(l_fee.getRent_end_dt())%></td>
                  <td class=title style="font-size : 8pt;" colspan="2">LPG장착</td>
                  <td class=title style="font-size : 8pt;" colspan="2">LPG탈착</td>
                  <td class=title style="font-size : 8pt;" colspan="4">출고지연대차</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">계약해지일</td>
                  <td align="center">&nbsp;<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
                  <td class=title style="font-size : 8pt;">시공업체</td>
                  <td class=title style="font-size : 8pt;">시공일자</td>
                  <td class=title style="font-size : 8pt;">시공업체</td>
                  <td class=title style="font-size : 8pt;">시공일자</td>
                  <td class=title style="font-size : 8pt;">차명</td>
                  <td class=title style="font-size : 8pt;">차량번호</td>
                  <td class=title style="font-size : 8pt;">개시일</td>
                  <td class=title style="font-size : 8pt;">종료일</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">LPG장착</td>
                  <td align="center"><%String lpg_yn = car.getLpg_yn();%><%if(lpg_yn.equals("Y")){%>장착<%}else if(lpg_yn.equals("N")){%>미장착<%}%></td>
                  <td align="center"><%=cha1.getCha_nm()%><%if(cha1.getCha_nm().equals("")){%><%=cha1.getCha_item()%><%}%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(cha1.getCha_st_dt())%></td>
                  <td align="center"><%=cha2.getCha_nm()%><%if(cha2.getCha_nm().equals("")){%><%=cha2.getCha_item()%><%}%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(cha2.getCha_st_dt())%></td>
                  <td align="center"><%=taecha.getCar_nm()%></td>
                  <td align="center"><%=taecha.getCar_no()%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%></td>
                </tr>
                <tr>
                  <td colspan="5" class=title style="font-size : 8pt;">영업담당</td>
                  <td colspan="5" class=title style="font-size : 8pt;">출고담당</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">회사명</td>
                  <td class=title style="font-size : 8pt;">영업소</td>
                  <td class=title style="font-size : 8pt;">성명</td>
                  <td class=title style="font-size : 8pt;">연락처</td>
                  <td class=title style="font-size : 8pt;">휴대폰</td>
                  <td class=title style="font-size : 8pt;">회사명</td>
                  <td class=title style="font-size : 8pt;">영업소</td>
                  <td class=title style="font-size : 8pt;">계약번호</td>
                  <td class=title style="font-size : 8pt;">전화/FAX</td>
                  <td class=title style="font-size : 8pt;">담당자</td>
                </tr>
                <tr align="center">
                  <td><%=mgr_bus.get("COM_NM")==null?"":mgr_bus.get("COM_NM")%></td>
                  <td><%=mgr_bus.get("CAR_OFF_NM")==null?"":mgr_bus.get("CAR_OFF_NM")%></td>
                  <td><%=mgr_bus.get("NM")==null?"":mgr_bus.get("NM")%></td>
                  <td><%=mgr_bus.get("O_TEL")==null?"":mgr_bus.get("O_TEL")%></td>
                  <td><%=mgr_bus.get("TEL")==null?"":mgr_bus.get("TEL")%></td>
                  <td><%=mgr_dlv.get("COM_NM")==null?"":mgr_dlv.get("COM_NM")%></td>
                  <td><%=mgr_dlv.get("CAR_OFF_NM")==null?"":mgr_dlv.get("CAR_OFF_NM")%></td>
                  <td><%=pur.getRpt_no()%></td>
                  <td><%=mgr_dlv.get("O_TEL")==null?"":mgr_dlv.get("O_TEL")%></td>
                  <td><%=mgr_dlv.get("NM")==null?"":mgr_dlv.get("NM")%></td>
              </tr>
                <tr>
                  <td colspan="2" class=title style="font-size : 8pt;">계약자변경/중도해지사유</td>
                  <td colspan="8">&nbsp;<%if(!cls.getCls_st().equals("")){%>[<%=cls.getCls_st()%>]&nbsp;<%=HtmlUtil.htmlBR(cls.getCls_cau())%><%}%></td>
                </tr>
                <tr>
                  <td colspan="2" class=title style="font-size : 8pt;">특기사항</td>
                  <td colspan="8">&nbsp;</td>
                </tr>
          </table>
	    </td>
    </tr>
    <tr>
        <td style='height:20' align="right"></td>
    </tr>    
    <tr>
        <td align='right'><span class="c"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></span></td>
    </tr>
</table>	
</body>
</html>
