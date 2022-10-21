<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.cls.*, acar.credit.*, acar.ext.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "09");
	
	//검색구분
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	
	//기본정보
	Hashtable fee_base = af_db.getFeebasecls3(m_id, l_cd);

	//대여스케줄 여부
	int scd_size = Integer.parseInt(a_db.getFeeScdYn(m_id, l_cd, "1"));

	//대여스케줄중 연체리스트
	Vector fee_scd = af_db.getFeeScdDly(m_id);
	int fee_scd_size = fee_scd.size();

	//해지정보
	ClsBean cls = as_db.getClsCase(m_id, l_cd);
	String cls_st = cls.getCls_st();
	
	int pp_amt = AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT"));
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(m_id, l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(fee_size));
	
	//해지의뢰정보
	ClsEtcBean clss = ac_db.getClsEtcCase(m_id, l_cd);
	
	Vector grts = ae_db.getExtScd(m_id, l_cd, "4");
	int grt_size = grts.size();
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
</head>
<body>
<form name='form1' method='post' action='cls_u_a.jsp'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='rent_way' value='<%=fee_base.get("RENT_WAY")%>'>
<input type='hidden' name='con_mon' value='<%=fee_base.get("TOT_CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_s_amt())%>'>
<input type='hidden' name='pp_s_amt' value='<%=AddUtil.parseDecimal(cls.getPp_s_amt())%>'>
<input type='hidden' name='ifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_s_amt())%>'>
<input type='hidden' name='fee_chk' value='<%=fee_base.get("FEE_CHK")%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='b_lst' value='<%=b_lst%>'> 
<input type='hidden' name='rent_st' value='<%=fee_base.get("RENT_ST")%>'> 
<input type='hidden' name='fee_size' value='<%=fee_size%>'> 

  <table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지내역</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='10%' class='title'>해지구분</td>
            <td width="40%"><select name="cls_st" disabled>
                <option value="1" <%if(cls.getCls_st().equals("계약만료"))%>selected<%%>>계약만료</option>
                <option value="8" <%if(cls.getCls_st().equals("매입옵션"))%>selected<%%>>매입옵션</option>
                <option value="9" <%if(cls.getCls_st().equals("폐차"))%>selected<%%>>폐차</option>
                <option value="2" <%if(cls.getCls_st().equals("중도해약"))%>selected<%%>>중도해약</option>
                <option value="3" <%if(cls.getCls_st().equals("영업소변경"))%>selected<%%>>영업소변경</option>
                <option value="4" <%if(cls.getCls_st().equals("차종변경"))%>selected<%%>>차종변경</option>
                <option value="5" <%if(cls.getCls_st().equals("계약승계"))%>selected<%%>>계약승계</option>
                <option value="6" <%if(cls.getCls_st().equals("매각"))%>selected<%%>>매각</option>
                <option value="7" <%if(cls.getCls_st().equals("출고전해지(신차)"))%>selected<%%>>출고전해지(신차)</option>
                <option value="10" <%if(cls.getCls_st().equals("개시전해지(재리스)"))%>selected<%%>>개시전해지(재리스)</option>
              </select> 
            </td>
            <td width='10%' class='title'>해지일</td>
            <td width="15%"><%=cls.getCls_dt()%></td>
            <td class='title' width="10%">이용기간</td>
            <td width="15%"> 
              <%=cls.getR_mon()%>개월 
              <%=cls.getR_day()%>일</td>
          </tr>
          <tr> 
            <td width='10%' class='title'>해지내역 </td>
            <td colspan="5"><%=cls.getCls_cau()%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
	<%if(cls.getGrt_amt()+cls.getRifee_s_amt()+cls.getRfee_s_amt() >0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선납금액 정산 [공급가]</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>		
    <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' align='right' colspan="3">항목</td>
                  <td class='title' width='35%' align="center">내용</td>
                  <td class='title' width="35%">비고</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="7">환<br>
                    불<br>
                    금<br>
                    액</td>
                  <td class='title' colspan="2">보증금(A)</td>
                  <td width="35%" class='title' > 
                    <input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                  <td class='title'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">개<br>
                    시<br>
                    대<br>
                    여<br>
                    료</td>
                  <td cwidth="15%" align="center" width="20%">경과기간</td>
                  <td width="35%" align="center"> 
                    <input type='text' size='3' name='ifee_mon' value='<%=cls.getIfee_mon()%>'  class='num' maxlength='4'>
                    개월&nbsp;&nbsp;&nbsp; 
                    <input type='text' size='3' name='ifee_day' value='<%=cls.getIfee_day()%>'  class='num' maxlength='4'>
                    일</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td cwidth="15%" align="center" width="20%">경과금액</td>
                  <td width="35%" align="center"> 
                    <input type='text' name='ifee_ex_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                  <td>=개시대여료×경과기간</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">잔여 개시대여료(B)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    원</td>
                  <td class='title'>=개시대여료-경과금액</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">선<br>
                    납<br>
                    금</td>
                  <td align='center' width="20%">월공제액 </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='pded_s_amt' value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                  <td>=선납금÷계약기간</td>
                </tr>
                <tr> 
                  <td align='center' width="20%">선납금 공제총액 </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='tpded_s_amt' value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    원</td>
                  <td>=월공제액×실이용기간</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">잔여 선납금(C)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                  <td class='title'>=선납금-선납금 공제총액</td>
                </tr>
                <tr> 
                  <td class='title' align='right' colspan="3">계</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='c_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                  <td class='title'>=(A+B+C)</td>
                </tr>
        </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
	<%}%>  
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미납입금액 정산 [공급가]</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>		
    <tr> 		  
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class="title" colspan="4">항목</td>
                  <td class="title" width='40%'> 내용</td>
                  <td class="title" width='35%'>비고</td>
                </tr>
                <tr> 
                  <td class="title" rowspan="18" width="5%">미<br>
                    납<br>
                    입<br>
                    금<br>
                    액</td>
                  <td colspan="3" class="title">과태료/범칙금(D)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='fine_amt' value='<%=AddUtil.parseDecimal(cls.getFine_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                 <tr> 
                  <td colspan="3" class="title">자기차량손해면책금(E)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='car_ja_amt' value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" rowspan="5" width="5%"><br>
                    대<br>
                    여<br>
                    료</td>
                  <td align="center" colspan="2">과부족</td>
                  <td width='40%' align="center">&nbsp; 
                    <input type='text' name='ex_di_amt' value='<%=AddUtil.parseDecimal(cls.getEx_di_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원&nbsp; </td>
                  <td width='35%'>&nbsp; </td>
                </tr>
                <tr> 
                  <td rowspan="2" align="center" width="10%">미납입</td>
                  <td width='5%' align="center">기간</td>
                  <td width='40%' align="center"> &nbsp; 
                    <input type='text' size='4' name='nfee_mon' value='<%=cls.getNfee_mon()%>'  class='num' maxlength='4'>
                    개월 
                    <input type='text' size='4' name='nfee_day' value='<%=cls.getNfee_day()%>'  class='num' maxlength='4'>
                    일</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">금액</td>
                  <td width='40%' align="center"> 
                    <input type='text' size='15' name='nfee_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                  <td width='35%'>매출 세금계산서 발행</td>
                </tr>
                <tr> 
                  <td colspan="2" align="center">연체료</td>
                  <td width='40%' align="center"> 
                    <input type='text' name='dly_amt' value='<%=AddUtil.parseDecimal(cls.getDly_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">대여료(F)</td>
                  <td class='title' width='40%' align="center">
                    <input type='text' name='d_amt' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td rowspan="6" class="title">중<br>
                    도<br>
                    해<br>
                    지<br>
                    위<br>
                    약<br>
                    금</td>
                  <td align="center" colspan="2">대여료총액</td>
                  <td width='40%' align="center"> 
                    <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                  <td width='35%'>=선납금+월대여료총액</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">월대여료(환산)</td>
                  <td width='40%' align="center"> 
                    <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                  <td width='35%'>=대여료총액÷계약기간</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">잔여대여계약기간</td>
                  <td width='40%' align="center"> 
                    <input type='text' name='rcon_mon' size='3' value='<%=cls.getRcon_mon()%>' class='num' maxlength='4'>
                    개월 
                    <input type='text' name='rcon_day' size='3' value='<%=cls.getRcon_day()%>' class='num' maxlength='4' >
                    일</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">잔여기간 대여료 총액</td>
                  <td width='40%' align="center"> 
                    <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원&nbsp;</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">위약금 적용요율</td>
                  <td width='40%' align="center"> 
                    <input type='text' name='dft_int' value='<%=cls.getDft_int()%>' size='5' class='num' maxlength='4'>
                    %</td>
                  <td width='35%'>잔여기간 대여료 총액 기준</td>
                </tr>
                <tr> 
                  <td  class="title" colspan="2">중도해지위약금(G)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='dft_amt' size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    원&nbsp;</td>
                  <td align="left"><%if(clss.getTax_chk0().equals("Y")){%>중도해지위약금 계산서 발행<%}%></td>
                </tr>
                           
                <tr> 
                 <td class="title" rowspan="5" width="5%"><br>
                    기<br>
                    타</td> 
                  <td colspan="2" class="title">차량회수외주비용(H)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='etc_amt' value='<%=AddUtil.parseDecimal(cls.getEtc_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                   <td align="left"><%if(clss.getTax_chk1().equals("Y")){%>차량회수외주비용 계산서 발행<%}%></td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">차량회수부대비용(I)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='etc2_amt' value='<%=AddUtil.parseDecimal(cls.getEtc2_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td align="left"><%if(clss.getTax_chk2().equals("Y")){%>차량회수부대비용 계산서 발행<%}%></td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">잔존차량가격(J)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='etc3_amt' value='<%=AddUtil.parseDecimal(cls.getEtc3_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">기타손해배상금(K)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='etc4_amt' value='<%=AddUtil.parseDecimal(cls.getEtc4_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td align="left"><%if(clss.getTax_chk3().equals("Y")){%>기타손해배상금 계산서 발행<%}%></td>
                </tr>
                 <input type='hidden' name='etc5_amt' value='<%=AddUtil.parseDecimal(cls.getEtc5_amt())%>'>
                <tr> 
                  <td colspan="2" class="title">부가세(L)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='no_v_amt' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td class='title' width='35%'>
				    <table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <%if(cls.getGrt_amt()+cls.getRifee_s_amt()+cls.getRfee_s_amt() >0){%>	
                      <tr> 
                        <td id=td_cancel_n style="display:''" class='title'>=(미납입금액-B-C) ×10%</td>
                      </tr>
					  <%}else{%>
                      <tr> 
                        <td id=td_cancel_n style="display:''" class='title'>=미납입금액 ×10%</td>
                      </tr>
					  <%}%>
                    </table>
				  </td>
                </tr>
                <tr> 
                  <td class="title" colspan="4">계(J)</td>
                  <td class='title' width='40%' align="center"> 
                    <input type='text' name='fdft_amt1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td class='title' width='35%'>=(D+E+F+G+H+I+J+K+L)</td>
                </tr>
        </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
          <tr> 
            <td class="line"> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="25%">고객납입금액</td>
                  <td class='title' width="40%" align="center"> 
                    <input type='text' name='fdft_amt2' value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>'size='15' class='num' maxlength='15'>
                    원</td>
                  <td class='title' width="35%"> =미납입금액계<%if(cls.getGrt_amt()+cls.getRifee_s_amt()+cls.getRfee_s_amt() >0){%>-환불금액계<%}%></td>
                </tr>
              </table>
            </td>
          </tr>
    <tr>
		<td class=h></td>
	</tr> 	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>수금스케줄</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10%  class='title'>회차</td>
                    <td width=15% class='title'>공급가</td>
                    <td width=15% class='title'>부가세</td>
                    <td width=15% class='title'>합계</td>
                    <td width=15% class='title'>입금예정일</td>
                    <td width=15% class='title'>입금일</td>
                    <td width=15% class='title'>입금액</td>
                </tr>
          <%		for(int i = 0 ; i < grt_size ; i++){
			ExtScdBean grt = (ExtScdBean)grts.elementAt(i);
			if(!grt.getExt_pay_dt().equals("")){%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>회<%if(!grt.getExt_tm().equals("1")){%>(잔액)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>원&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>원&nbsp;</td>
                    <td align='right'><input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
        			원&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='<%=Util.parseDecimal(grt.getExt_pay_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>
                </tr>
          <%			}else{%>
                <tr> 
                    <td align='center'><%=grt.getExt_tm()%>회<%if(!grt.getExt_tm().equals("1")){%>(잔액)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%>원&nbsp;</td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%>원&nbsp;</td>
                    <td align='right'> <input type='text' name='t_grt_amt' value='<%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%>' class='whitenum' readonly size="10">
                      원&nbsp;</td>
                    <td align='center'> <input type='text' name='t_grt_est_dt' size='11' value='<%=grt.getExt_est_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                    </td>
                    <td align='center'> <input type='text' name='t_grt_pay_dt' size='11' value='<%=grt.getExt_pay_dt()%>' class='whitetext' maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value);'> 
                    </td>
                    <td align='right'> <input type='text' name='t_grt_pay_amt' size='10' class='whitenum' maxlength='10' value='' onBlur='javascript:this.value=parseDecimal(this.value)'>
                      원&nbsp;</td>			
                </tr>
          <%			}
		}%>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td align=right><a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>    		
  </table>
</form>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;	
		<%if(cls.getGrt_amt()+cls.getRifee_s_amt()+cls.getRfee_s_amt() >0){%>	
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value)));
		<%}%>
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));		
	}
//-->
</script>

<iframe src="about:blank" name="i_no" width="100" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
