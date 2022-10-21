<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>
</head>
<body leftmargin="15" topmargin="1">
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 

	
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	double img_width 	= 680;
	double img_height 	= 1009;

	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//단기관리자-연대보증인
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(s_cd, "4");	
	
	String print_car_no = "";
	String print_car_nm = "";	
	String reg_dt = Util.getDate();
%>

<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
  <tr colspan=2>
    <td colspan=10>
      <table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td><center><font size="4" face="궁서체">>>
                    <%if(rc_bean.getRent_st().equals("1")){%>
                    단기대여 
                    <%}else if(rc_bean.getRent_st().equals("2")){%>
                    정비대차 
                    <%}else if(rc_bean.getRent_st().equals("3")){%>
                    사고대차 
                    <%}else if(rc_bean.getRent_st().equals("9")){%>
                    보험대차 
                    <%}else if(rc_bean.getRent_st().equals("10")){%>
                    지연대차 		
                    <%}else if(rc_bean.getRent_st().equals("4")){%>
                    업무대여 
                    <%}else if(rc_bean.getRent_st().equals("5")){%>
                    업무지원 
                    <%}else if(rc_bean.getRent_st().equals("6")){%>
                    차량정비 
                    <%}else if(rc_bean.getRent_st().equals("7")){%>
                    차량점검 
                    <%}else if(rc_bean.getRent_st().equals("8")){%>
                    사고수리 
                    <%}else if(rc_bean.getRent_st().equals("11")){%>
                    기타 
                    <%}else if(rc_bean.getRent_st().equals("12")){%>
                    월렌트
                    <%}%>                     
                    <%if(!rc_bean.getRent_st().equals("12")){%>
                    서비스 
                    <%}%>
                    계약서 <<
                </font>
                </center>
          </td>
        </tr>
            </table>
    	</td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>			
        <td align="right">&nbsp;</td>			
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span></td>
        <td align="right">&nbsp;</td>			
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="15%" class=title>차량번호</td>
                  <td width="35%">&nbsp;<input name="car_no" type="text" class="whitetext" value="<%=reserv.get("CAR_NO")%>" size="15"></td>
                  <td width="15%" class=title>차명</td>
                  <td width="35%">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                </tr>
                <tr>
                  <td width="15%" class=title>최초등록일</td>
                  <td width="35%">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                  <td width="15%" class=title>차대번호</td>
                  <td width="35%">&nbsp;<%=reserv.get("CAR_NUM")%></td>
                </tr>
                <tr>
                  <td width="15%" class=title>출고일자</td>
                  <td width="35%">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("DLV_DT")))%></td>
                  <td width="15%" class=title>배기량</td>
                  <td width="35%">&nbsp;<%=reserv.get("DPM")%>cc</td>
                </tr>
                <tr>
                  <td width="15%" class=title>칼라</td>
                  <td width="35%">&nbsp;<%=reserv.get("COLO")%></td>
                  <td width="15%" class=title>연료</td>
                  <td width="35%">&nbsp;<%=reserv.get("FUEL_KD")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_cust_nm style="display:<%if(rc_bean.getRent_st().equals("1")||rc_bean.getRent_st().equals("2")||rc_bean.getRent_st().equals("3")||rc_bean.getRent_st().equals("4")||rc_bean.getRent_st().equals("5")||rc_bean.getRent_st().equals("9")||rc_bean.getRent_st().equals("10")||rc_bean.getRent_st().equals("12")) {%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>
        <td align="right"></td>
    </tr>
    <%if(rc_bean.getRent_st().equals("1")||rc_bean.getRent_st().equals("9")||rc_bean.getRent_st().equals("12")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="15%" class=title>구분</td>
                  <td colspan="3">&nbsp;<%=rc_bean2.getCust_st()%> </td>
                </tr>
                <tr> 
                    <td width="15%" class=title>상호</td>
                    <td width="35%">&nbsp; <%=rc_bean2.getFirm_nm()%></td>
                    <td width="15%" class=title>성명</td>
                    <td width="35%">&nbsp;<%=rc_bean2.getCust_nm()%></td>
                </tr>
                <tr> 
                    <td width="15%" class=title>사업자번호</td>
                    <td width="35%">&nbsp;<%=rc_bean2.getEnp_no()%> </td>
                    <td width="15%" class=title><%if(rc_bean2.getCust_st().equals("개인")) {%>주민 <%}else{%>법인 <%}%>번호</td>
                    <td width="35%">&nbsp;
                      <%if(rc_bean2.getCust_st().equals("개인")){%>
                        <%=AddUtil.subData((String)rc_bean2.getSsn(),6)%>-<%if(rc_bean2.getSsn().length() > 6){%><%=rc_bean2.getSsn().substring(6,7)%><%}%>******
                      <%}else{%>
                        <%=rc_bean2.getSsn()%>
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td width="15%" class=title>주소</td>
                    <td colspan="3">&nbsp;<%=rc_bean2.getZip()%>
                        &nbsp; 
                        <%=rc_bean2.getAddr()%>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=15%>면허번호</td>
                    <td>&nbsp;<%=rm_bean4.getLic_no()%>
                    </td>
                    <td class=title>면허종류</td>
                    <td>&nbsp;<%if(rm_bean4.getLic_st().equals("1")){%>2종보통<%}%>
                        <%if(rm_bean4.getLic_st().equals("2")){%>1종보통<%}%>
                        <%if(rm_bean4.getLic_st().equals("3")){%>1종대형<%}%>
                    </td>
                </tr>
                <tr>
                  <td width="15%" class=title>전화번호</td>
                  <td>&nbsp;<%=rm_bean4.getTel()%> </td>
                  <td class=title>휴대폰</td>
                  <td>&nbsp;<%=rm_bean4.getEtc()%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rc_bean.getRent_st().equals("2") || rc_bean.getRent_st().equals("3") || rc_bean.getRent_st().equals("10")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width="15%" class=title>구분</td>
                <td colspan="3">&nbsp;<%=rc_bean2.getCust_st()%> </td>
              </tr>
              <tr>
                <td width="15%" class=title>상호 </td>
                <td width="35%">&nbsp; <%=rc_bean2.getFirm_nm()%> </td>
                <td width="15%" class=title>성명</td>
                <td width="35%">&nbsp;<%=rc_bean2.getCust_nm()%> </td>
              </tr>
              <tr>
                <td width="15%" class=title>사업자번호</td>
                <td width="35%">&nbsp;<%=rc_bean2.getEnp_no()%> </td>
                <td width="15%" class=title><%if(rc_bean2.getCust_st().equals("개인")) {%>주민 <%}else{%>법인 <%}%>번호</td>
                <td width="35%">&nbsp;<%if(rc_bean2.getCust_st().equals("개인")){%>
                  <%=rc_bean2.getSsn().substring(0,6)%>-*******
                    <%}else{%>
                    <%=rc_bean2.getSsn()%>
                    <%}%> </td>
              </tr>
              <tr>
                <td class=title>사업장주소</td>
                <td colspan="3">&nbsp;<%=rc_bean2.getZip()%> &nbsp; <%=rc_bean2.getAddr()%> </td>
              </tr>
              <tr>
                <td class=title>전화번호</td>
                <td>&nbsp;<%=rc_bean2.getTel()%> </td>
                <td class=title>휴대폰</td>
                <td>&nbsp;<%=rc_bean2.getM_tel()%> </td>
              </tr>
            </table></td>
    </tr>	
    <%}else if(rc_bean.getRent_st().equals("4") || rc_bean.getRent_st().equals("5")){%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>구분</td>
                    <td width=35%>&nbsp;아마존카 직원
                    </td>
                    <td class=title width=15%>성명</td>
                    <td width=35%>&nbsp;<%=c_db.getNameById(rc_bean2.getCust_id(),"USER")%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}%>
    <tr><td class=h></td></tr>
	<%if(rc_bean.getRent_st().equals("10")){
		//지연대차정보
		//대차종료후 다른차 대차중일때 이전 대차계약의 과태료가 부과되면 최근 대차정보를 가져와서 다른 차량이 조회됨(아래로변경 20190306)
		Hashtable serv = rs_db.getInfoTeacha2(rc_bean.getSub_l_cd(), String.valueOf(reserv.get("CAR_NO")));
		if(String.valueOf(serv.get("CAR_NM")).equals("null")){
			serv = rs_db.getInfoTeacha(rc_bean.getCust_id(), String.valueOf(reserv.get("CAR_NO")));
		}
		print_car_no = String.valueOf(serv.get("CAR_NO"));
		print_car_nm = String.valueOf(serv.get("CAR_NM"));
		if(print_car_no.equals("null")){ print_car_no="";}
		if(print_car_nm.equals("null")){ print_car_nm="";}
	%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>지연대차</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100% >
                <tr>
                  <td width="15%" class=title style='height:38'>차량번호</td>
                  <td width="35%">&nbsp;<%=print_car_no%></td>
                  <td width="15%" class=title>차종</td>
                  <td width="35%">&nbsp;<%=print_car_nm%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>	
	<%}else if(rc_bean.getRent_st().equals("2")){
		//정비대차정보
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정비대차</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="15%" style='height:38'>정비공장</td>
                    <td colspan="3">&nbsp;<%=serv.get("OFF_NM")==null?"":serv.get("OFF_NM")%>
                    </td>
                </tr>
                <tr>
                  <td width="15%" class=title style='height:38'>정비차량번호</td>
                  <td width="35%">&nbsp;<%=serv.get("CAR_NO")==null?"":serv.get("CAR_NO")%></td>
                  <td width="15%" class=title>차종</td>
                  <td width="35%">&nbsp;<%=serv.get("CAR_NM")==null?"":serv.get("CAR_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>	
	<%}else if(rc_bean.getRent_st().equals("3")){
		//사고대차정보
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());
	%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고대차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="15%" class=title>정비공장</td>
                  <td colspan="3">&nbsp;<input name="off_nm" type="text" class="whitetext" value="<%=accid.get("OFF_NM")==null?"":accid.get("OFF_NM")%>" size="80"></td>
                </tr>
                <tr> 
                    <td class=title width=15%>피해차량번호</td>
                    <td width=35%>&nbsp;<input name="a_car_no" type="text" class="whitetext" value="<%=accid.get("CAR_NO")==null?"":accid.get("CAR_NO")%>" size="30">
                  </td>
                    <td class=title width=15%>차종</td>
                    <td width=35%>&nbsp;<input name="a_car_nm" type="text" class="whitetext" value="<%=accid.get("CAR_NM")==null?"":accid.get("CAR_NM")%>" size="30">
                    </td>
                </tr>
                <tr> 
                    <td width="15%" class=title> 접수번호</td>
                    <td width="35%"> 
                      &nbsp;<input name="a_p_num" type="text" class="whitetext" value="<%=accid.get("P_NUM")==null?"":accid.get("P_NUM")%>" size="30">
                    </td>
                    <td width="15%" class=title>가해자보험사</td>
                    <td width="35%"> 
                      &nbsp;<input name="a_g_ins" type="text" class="whitetext" value="<%=accid.get("G_INS")==null?"":accid.get("G_INS")%>" size="30">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rc_bean.getRent_st().equals("9")){
		//보험대차정보
		RentInsBean ri_bean = rs_db.getRentInsCase(s_cd);%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험대차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="15%" class=title> 접수번호</td>
                    <td width="20%"> 
                      &nbsp;<%=ri_bean.getIns_num()%>
                    </td>
                    <td width="10%" class=title>보험사</td>
                    <td width="30%">&nbsp;<%=c_db.getNameById(ri_bean.getIns_com_id(), "INS_COM")%></td>
                    <td width="10%" class=title> 담당자</td>
                    <td width="15%">&nbsp;
                        <%=ri_bean.getIns_nm()%>
                    </td>
                </tr>
                <tr>
                  <td width="15%" class=title>연락처Ⅰ</td>
                  <td>&nbsp;<%=ri_bean.getIns_tel()%>
                  </td>
                  <td width="10%" class=title>연락처Ⅱ</td>
                  <td>&nbsp;<%=ri_bean.getIns_tel2()%>
                  </td>
                  <td width="10%" class=title>팩스</td>
                  <td>&nbsp;<%=ri_bean.getIns_fax()%>
                  </td> 
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>		
	<%}else if(rc_bean.getRent_st().equals("6")){
		//차량정비정보
		Hashtable serv = rs_db.getInfoServ(c_id, rc_bean.getServ_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정비</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>
        			정비공장</td>
                    <td width=35%> 
                      &nbsp;<%=serv.get("OFF_NM")%>
                  </td>
                    <td class=title width=15%> 정비일자</td>
                    <td width=35%>
                      &nbsp;<%=AddUtil.ChangeDate2(String.valueOf(serv.get("SERV_DT")))%>
                  </td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr><td class=h></td></tr>	
	<%}else if(rc_bean.getRent_st().equals("7")){
		//차량점검정보
		Hashtable maint = rs_db.getInfoMaint(c_id, rc_bean.getMaint_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정검</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>검사유효기간</td>
                    <td width=85%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%> 
                  </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rc_bean.getRent_st().equals("8")){
		//사고수리정보
		Hashtable accid = rs_db.getInfoAccid(c_id, rc_bean.getAccid_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고수리</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15% style='height:37'>정비공장</td>
                    <td width=35%>&nbsp;<%=accid.get("OFF_NM")%>
                  </td>
                    <td class=title width=10%>사고일자</td>
                    <td width=20%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%>
                  </td>
                    <td class=title width=10%>담당자</td>
                    <td width=10%>&nbsp;<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%>
                  </td>
                </tr>
                <tr> 
                    <td width="15%" class=title> 사고내용</td>
                    <td colspan="5">&nbsp;<%=accid.get("ACCID_CONT")%>&nbsp;<%=accid.get("ACCID_CONT2")%>
                    </td>
                </tr>
          </table>
        </td>
    </tr>		
	<%}%>
	<tr><td class=h></td></tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>계약일자</td>
                    <td width=20%>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
                    <td class=title width=10%>영업소</td>
                    <td width=25%>&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(),"BRCH")%>
                    </td>
                    <td width=10% class=title>담당자</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(),"USER")%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>기타</td>
                    <td colspan="5">&nbsp;<%=rc_bean.getEtc()%>
                    </td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차/반차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="15%" class=title>배차예정일</td>
                    <td width="35%">&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%>
                    </td>
                    <td width="15%" class=title>반차예정일</td>
                    <td width="35%">&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=15%>배차일자</td>
                    <td width=35%>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%>
                    </td>
                    <td class=title width=15%>반차일자</td>
                    <td width=35%>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%>
        			</td>
                </tr>
                <tr> 
                    <td width="15%" class=title>배차위치</td>
                    <td width="35%">&nbsp;<%=rc_bean.getDeli_loc()%>
                    </td>
                    <td width="15%" class=title>반차위치</td>
                    <td width="35%">&nbsp;<%=rc_bean.getRet_loc()%>
					</td>
                </tr>
          </table>
        </td>
    </tr>
<!-- 사고대차 화면 출력 양식 요청해서 임시로 작업함. 2009-05-08 여기서 부터-->    
	<tr>
		<td height=15></td>
	</tr>
	<%
			Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());
			
			if(!rc_bean.getRent_st().equals("10") && print_car_no.equals("")){
				print_car_no = String.valueOf(serv.get("CAR_NO"));
				print_car_nm = String.valueOf(serv.get("CAR_NM"));
			}
			if(print_car_no.equals("null")){ print_car_no="";}
			if(print_car_nm.equals("null")){ print_car_nm="";}
	%>
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;
    	  <%if(rc_bean.getRent_st().equals("12")){%>
    	  위 고객은 <b><%=reserv.get("CAR_NO")%> <%=reserv.get("CAR_NM")%> </b>차량을 월렌트계약하여 <b><%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%> ~ <%if(!rc_bean.getRet_dt_d().equals("")){%><%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%><%}else{%><%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%><%}%></b> 까지 제공함을 증명함.
    	  <%}else{%>
    	  위 고객은 <b><input name="car_no2" type="text" class="whitetext" value="<%=print_car_no%>" size="12"> <%=print_car_nm%> </b>차량을 <%if(rc_bean.getRent_st().equals("10")){%>장기계약하였으나 미출고로 지연대차서비스를<%}else{%>장기계약하여 이용하던중 대차 서비스를<%}%> <b><%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%> ~ <p>&nbsp;&nbsp;&nbsp;<%if(!rc_bean.getRet_dt_d().equals("")){%><%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%><%}else{%><%=reg_dt%><%}%></b> 까지 <b><input name="car_no3" type="text" class="whitetext" value="<%=reserv.get("CAR_NO")%>" size="12"></b> 차량으로 제공 하였슴을 증명함.
    	  <%}%>
    	</td>
    </tr>
	<tr>
		<td align=right><img src=/acar/images/pay_h_ceo.gif></td>
	</tr>    
<!-- 여기까지 -->	
</table>
</body>
</html>