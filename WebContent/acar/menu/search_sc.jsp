<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.cont.*, acar.client.*, acar.car_register.*, acar.debt.*, acar.insur.*"%>
<%@ page import="acar.common.*, acar.fee.*"%>
<jsp:useBean id="lr_db" scope="page" class="cust.rent.LongRentDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	
	String q_kd1 = request.getParameter("q_kd1")==null?"":request.getParameter("q_kd1");
	String q_kd2 = request.getParameter("q_kd2")==null?"2":request.getParameter("q_kd2");
	String q_wd = request.getParameter("q_wd")==null?"":request.getParameter("q_wd");//검색어
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	
	//계약:고객관련
	Hashtable cont_view = lr_db.getLongRentCaseH(m_id, l_cd);
	//고객정보
	ClientBean client = al_db.getClient(String.valueOf(cont_view.get("CLIENT_ID")));
	//차량정보
	ContCarBean car = a_db.getContCar(m_id, l_cd);
	//차량정보
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(c_id);
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	/* 구매사항 설정 */
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	//car_etc
	ContBaseBean base = a_db.getContBaseAll(m_id, l_cd);
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgr(m_id, l_cd);
	int mgr_size = car_mgrs.size();	
	//대여정보
	ContFeeBean fee = a_db.getContFee(m_id, l_cd, "1");
	//출고전 대차 Y 인 경우, 출고전대차 조회
	Vector taec = a_db.getContTaecha(m_id,l_cd);
	int taec_size =taec.size();
	//연장계약사이즈
	int ext_cnt = af_db.getMaxRentSt(m_id,l_cd);
	//할부정보
	ContDebtBean debt = ad_db.getContDebtReg(m_id, l_cd);
	//근저당정보
	CltrBean cltr = ad_db.getBankLend_mapping_cltr(m_id, l_cd);
	//보험정보
	InsDatabase ai_db = InsDatabase.getInstance();
	String ins_st = ai_db.getInsSt(c_id);
	acar.insur.InsurBean ins = ai_db.getInsCase(c_id, ins_st);
%> 

<html>
<head>
<title>:: 빠른검색 ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
/*	function search(){
		var fm = document.form1;	
		fm.submit();
	}
	*/
	function enter(q_kd2) {
		var fm = document.form1;
		fm.q_kd2.value = q_kd2;
		if(q_kd2 == '1')		fm.q_wd.value = fm.firm_nm.value;
		else if(q_kd2 == '2')	fm.q_wd.value = fm.car_no.value;
		var keyValue = event.keyCode;
		if (keyValue =='13') fm.submit();
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='search_sh.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="q_kd2" value='<%=q_kd2%>'>
<input type='hidden' name="q_wd" value='<%=q_wd%>'>
  <table width="830" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="750"> 
        <table width="750" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td colspan="3">&lt; 계약 &gt; </td>
          </tr>
          <tr> 
            <td class=line colspan="3"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td class=title width="70">계약번호</td>
                  <td width="110"><%=l_cd%></td>
                  <td class=title width="70">계약일자</td>
                  <td width="110"><%=cont_view.get("RENT_DT")%></td>
                  <td class=title width="70">계약구분</td>
                  <td width="110">
                    <%if(String.valueOf(cont_view.get("RENT_ST")).equals("1")){%>
                    신규 
                    <%}else if(String.valueOf(cont_view.get("RENT_ST")).equals("3")){%>
                    대차 
                    <%}else if(String.valueOf(cont_view.get("RENT_ST")).equals("4")){%>
                    증차 
                    <%}else if(String.valueOf(cont_view.get("RENT_ST")).equals("5")){%>
                    연장(12개월미만) 
                    <%}else if(String.valueOf(cont_view.get("RENT_ST")).equals("2")){%>
                    연장(12개월이상) 
                    <%}else if(String.valueOf(cont_view.get("RENT_ST")).equals("6")){%>
                    보유차(6개월이상) 					
                    <%}%>				  
				  </td>
                  <td class=title width="70">차량구분</td>
                  <td>
                    <%if(String.valueOf(cont_view.get("CAR_ST")).equals("1")){%>
                    장기렌트 
                    <%}else if(String.valueOf(cont_view.get("CAR_ST")).equals("2")){%>
                    보유차 
                    <%}else if(String.valueOf(cont_view.get("CAR_ST")).equals("3")){%>
                    리스플러스 
                    <%}%>
                  </td>
                </tr>
                <tr> 
                  <td class=title>대여방식</td>
                  <td><%=cont_view.get("RENT_WAY")%></td>
                  <td class=title>대여개월</td>
                  <td><%=cont_view.get("CON_MON")%>개월</td>
                  <td class=title>대여개시일</td>
                  <td><%=cont_view.get("RENT_START_DT")%></td>
                  <td class=title>대여만료일</td>
                  <td><%=cont_view.get("RENT_END_DT")%></td>
                </tr>
                <tr> 
                  <td class=title>영업소</td>
                  <td><%=c_db.getNameById(String.valueOf(cont_view.get("BRCH_ID")),"BRCH")%></td>
                  <td class=title>최초영업자</td>
                  <td><%=c_db.getNameById(String.valueOf(cont_view.get("BUS_ID")),"USER")%></td>
                  <td class=title>영업담당자</td>
                  <td><%=c_db.getNameById(String.valueOf(cont_view.get("BUS_ID2")),"USER")%></td>
                  <td class=title>관리담당자</td>
                  <td><%=c_db.getNameById(String.valueOf(cont_view.get("MNG_ID")),"USER")%></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3">&lt; 고객 &gt; </td>
          </tr>
          <tr> 
            <td class=line>
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td class=title width="70">상호</td>
                  <td width="180"> 
                    <input type="text" name="firm_nm" value="<%=cont_view.get("FIRM_NM")%>" size="25" class=text onKeyDown="javasript:enter('1')">
                  </td>
                  <td class=title width="70">대표자</td>
                  <td width="160"><%=cont_view.get("CLIENT_NM")%></td>
                </tr>
                <tr> 
                  <td class=title>사용본거지</td>
                  <td colspan="3"><%=cont_view.get("R_SITE")%></td>
                </tr>
                <tr> 
                  <td class=title>사무실</td>
                  <td><%= client.getO_tel()%></td>
                  <td class=title>팩스</td>
                  <td><%= client.getFax()%></td>
                </tr>
              </table>
            </td>
            <td>&nbsp;</td>
            <td class=line>
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <%//법인고객차량관리자
					if(mgr_size > 0){
						for(int i = 0 ; i < 3 ; i++){
							CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);%>			  
                <tr> 
                  <td class=title width="70"><%= mgr.getMgr_st()%></td>
                  <td width="200"><%= mgr.getMgr_nm()%>(<%= mgr.getMgr_tel()%>/<%= mgr.getMgr_m_tel()%>)</td>
                </tr>
                <%		}
					}%>				
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3">&lt; 자동차 &gt; </td>
          </tr>
          <tr> 
            <td class=line colspan="3"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td class=title width="70">차량번호</td>
                  <td width="110"> 
                    <input type="text" name="car_no" value="<%=cont_view.get("CAR_NO")%>" size="15" class=text onKeyDown="javasript:enter('2')">
                  </td>
                  <td class=title width="70">차명</td>
                  <td colspan="5"><%=mst.getCar_nm()%>&nbsp;<%=mst.getCar_name()%></td>
                </tr>
                <tr> 
                  <td class=title>출고일자</td>
                  <td><%=base.getDlv_dt()%><%if(base.getDlv_dt().equals("")){%><%=pur.getDlv_con_dt()%>(예정)<%}%></td>
                  <td class=title>계출번호</td>
                  <td width="120"><%=pur.getRpt_no()%></td>
                  <td class=title width="70">최초등록일</td>
                  <td width="110"><%=cr_bean.getInit_reg_dt()%></td>
                  <td class=title width="70">차대번호</td>
                  <td><%=cr_bean.getCar_num()%></td>
                </tr>
                <tr> 
                  <td class=title>지역</td>
                  <td>
				    <%if(cr_bean.getCar_ext().equals("1"))%>서울<%%>
					<%if(cr_bean.getCar_ext().equals("2"))%>경기<%%></td>
                  <td class=title>차종</td>
                  <td>
                    <%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>  					
				  </td>
                  <td class=title>배기량</td>
                  <td><%=cr_bean.getDpm()%>cc</td>
                  <td class=title>연료</td>
                  <td>
                    <%=c_db.getNameByIdCode("0039", "", cr_bean.getFuel_kd())%>                  	
				  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3">&lt; 대여 &gt; </td>
          </tr>
          <tr> 
            <td class=line colspan="3"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
			  <%if(taec_size > 0){%>
				<%	for(int i = 0 ; i < taec_size ; i++){
						ContTaechaBean taecha = (ContTaechaBean)taec.elementAt(i);	
				%>			  
                <tr> 
                  <td class=title <%if(taec_size >1){%>rowspan=<%=taec_size%><%}%>>대차</td>
                  <td class=title>기간</td>
                  <td><%=taecha.getCar_rent_tm()%>개월</td>
                  <td class=title>대여개시일</td>
                  <td><%=taecha.getCar_rent_st()%></td>
                  <td class=title>대여만료일</td>
                  <td><%=taecha.getCar_rent_et()%></td>
                  <td class=title>차량번호</td>
                  <td><%=taecha.getCar_no()%></td>
                  <td class=title>차명</td>
                  <td><%=c_db.getNameById(taecha.getCar_id(), "CAR_NM")%></td>
                </tr>
				<%	}%>
			  <%}%>				
                <tr> 
                  <td class=title rowspan="2">신차</td>
                  <td class=title>기간</td>
                  <td> 36개월</td>
                  <td class=title width="70">대여개시일</td>
                  <td><%=fee.getRent_start_dt()%></td>
                  <td class=title width="70">대여만료일</td>
				  <%if(taec_size > 0){%>
                  <td><%=fee.getRent_end_dt()%></td>				  
                  <td class=title colspan="3">출고전대차기간 포함여부</td>
                  <td><%if(fee.getPrv_mon_yn().equals("0")){%>미포함<%}%><%else if(fee.getPrv_mon_yn().equals("1")){%>포함<%}%></td>
				  <%}else{%>
                  <td colspan="5"><%=fee.getRent_end_dt()%></td>				  
				  <%}%>				  
                </tr>
                <tr> 
                  <td class=title>보증금</td>
                  <td><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>원</td>
                  <td class=title>선납금</td>
                  <td><%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>원</td>
                  <td class=title>개시대여료</td>
                  <td><%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>원</td>
                  <td class=title>월대여료</td>
                  <td><%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>원</td>
                  <td class=title>매입옵션</td>
                  <td><%=AddUtil.parseDecimal(fee.getOpt_s_amt()+fee.getOpt_v_amt())%>원/<%=fee.getOpt_per()%>%</td>
                </tr>
				<%if(ext_cnt > 1){%>
				<%	for(int i=1; i<ext_cnt; i++){
						ContFeeBean ext_fee = a_db.getContFee(m_id, l_cd, Integer.toString(i));%>
                <tr> 
                  <td class=title rowspan="2">연장<br>
                    <%=i%></td>
                  <td class=title>기간</td>
                  <td><%=ext_fee.getCon_mon()%>개월</td>
                  <td class=title>대여개시일</td>
                  <td><%=ext_fee.getRent_start_dt()%></td>
                  <td class=title>대여만료일</td>
                  <td><%=ext_fee.getRent_end_dt()%></td>
                  <td class=title>계약담당자</td>
                  <td ><%=c_db.getNameById(ext_fee.getExt_agnt(),"USER")%></td>
                  <td class=title>계약일자</td>
                  <td><%=ext_fee.getRent_dt()%></td>				  
                </tr>
                <tr> 
                  <td class=title>보증금</td>
                  <td><%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>원</td>
                  <td class=title>선납금</td>
                  <td><%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>원</td>
                  <td class=title>개시대여료</td>
                  <td><%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>원</td>
                  <td class=title>월대여료</td>
                  <td colspan="3"><%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>원</td>
                </tr>
				<%	}%>
				<%}%>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3">&lt; 할부/근저당 &gt;</td>
          </tr>
          <tr> 
            <td class=line colspan="3"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td class=title width="70">금융사</td>
                  <td width="90"><%=c_db.getNameById(debt.getCpt_cd(),"BANK")%></td>
                  <td class=title width="70">대출일자</td>
                  <td width="80"><%=debt.getLend_dt()%></td>
                  <td class=title width="70">대출금액</td>
                  <td width="80"><%=Util.parseDecimal(debt.getLend_prn())%>원</td>
                  <td class=title width="70">대출번호</td>
                  <td width="100"><%=debt.getLend_no()%></td>
                  <td class=title width="70">할부횟수</td>
                  <td width="50"><%=debt.getTot_alt_tm()%>회</td>
                </tr>
                <tr> 
                  <td class=title>설정약정액</td>
                  <td><%=Util.parseDecimal(cltr.getCltr_amt())%>원</td>
                  <td class=title>설정일자</td>
                  <td><%=cltr.getCltr_set_dt()%></td>
                  <td class=title>말소등록일</td>
                  <td><%=cltr.getCltr_exp_dt()%></td>
                  <td class=title>말소사유</td>
                  <td colspan="3"><%=cltr.getCltr_exp_cau()%></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3">&lt; 자동차보험 &gt;</td>
          </tr>
          <tr> 
            <td class=line colspan="3"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td class=title width="70">보험사</td>
                  <td width="90"><%=c_db.getNameById(ins.getIns_com_id(),"INS_COM")%></td>
                  <td class=title width="70">보험기간</td>
                  <td width="150"><%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>~<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%></td>
                  <td class=title width="70">연령범위</td>
                  <td width="70">
				    <%if(ins.getAge_scp().equals("1")){%>21세이상<%}%> 
                	<%if(ins.getAge_scp().equals("2")){%>26세이상<%}%> 
                	<%if(ins.getAge_scp().equals("3")){%>모든운전자<%}%>
				  </td>
                  <td class=title width="60">에어백</td>
                  <td width="60"><%if(ins.getAir_ds_yn().equals("Y") && ins.getAir_as_yn().equals("Y")){%>2개<%}else if(ins.getAir_ds_yn().equals("Y") && ins.getAir_as_yn().equals("N")){%>1개<%}%></td>
                  <td class=title  width="40">특약</td>
                  <td width="70"><%=ins.getVins_spe()%></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td align="center" colspan="3"> 
              <hr>
            </td>
          </tr>
          <tr> 
            <td align="center" colspan="3">차량번호이력 || 계약이력 || 과태료이력 || 정비이력 || 
              사고이력 || 보험이력 || 예약시스템이력</td>
          </tr>
        </table>
      </td>
      <td width="80" valign="top" align="right"> 
        <table width="70" border="1" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="63" align="center">&lt;이동&gt;</td>
          </tr>
          <tr> 
            <td width="63"><a href="#">계약관리</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">자동차관리</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">고객관리</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">대여료</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">선수금</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">과태료</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">면책금</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">휴/대차료</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">중도해지</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">미수금관리</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">할부금</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">보험료</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">지급수수료</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">기타비용</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">차량정비</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">고객방문</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">사고</a></td>
          </tr>
          <tr> 
            <td width="63"><a href="#">보험</a></td>
          </tr>
          <tr> 
            <td width="63">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td width="750">&nbsp;</td>
      <td width="50">&nbsp;</td>
    </tr>
  </table>
  </form>
</body>
</html>
<script language="JavaScript">
</script>