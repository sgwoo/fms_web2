<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*, acar.doc_settle.*, acar.fee.*, acar.forfeit_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");	
	String im_seq	 	= request.getParameter("im_seq")==null?"":request.getParameter("im_seq");	
	
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");	
	String seq_no		= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");	
	String doc_dt		= request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt");	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());		
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(base.getCar_mng_id());	
	
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	
	//분할청구정보
	Vector rtn = af_db.getFeeRtnList(rent_mng_id, rent_l_cd, ext_fee.getRent_st());
	int rtn_size = rtn.size();
	
	//임의연장
	FeeImBean im = af_db.getFeeIm(rent_mng_id, rent_l_cd, "1", im_seq);
	
	//영업담당자
	user_bean 	= umd.getUsersBean(base.getBus_id());
	
	long total_amt 	= 0;
	
	
	Hashtable fine = new Hashtable();
		
	if(rent_st.equals("") || rent_st.equals("null")){
		fine = afm_db.getFineExpListExcel(rent_mng_id, rent_l_cd, car_mng_id, seq_no);
	}else{
		fine = afm_db.getFineExpListExcel(rent_mng_id, rent_l_cd, car_mng_id, seq_no, rent_st);
	}
	
	String rent_start_dt = "";
	String rent_end_dt = "";
	
	if(!String.valueOf(fine.get("RENT_START_DT")).equals("")){
		rent_start_dt = String.valueOf(fine.get("RENT_START_DT"));
		rent_end_dt   = String.valueOf(fine.get("RENT_END_DT"));		
	}
	
	/*2016-04-14 추가 gillsun */
	//임의연장
	Vector imvt = af_db.getFeeImList(rent_mng_id, rent_l_cd, rent_st);
	int imvt_size = imvt.size();
	
	Hashtable fee_im = af_db.getfee_minmax(rent_mng_id, rent_l_cd);
	
	//계약전부
	Vector im_cont = af_db.im_rent_cont(rent_mng_id, rent_l_cd);
	int im_cont_size = im_cont.size();
	
	String imh_stdt = "";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st"	 	value="<%=rent_st%>">
  <input type='hidden' name="im_seq" 		value="<%=im_seq%>">             

        
<table border='0' cellspacing='0' cellpadding='0' width='650'>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
				<td><center><font size="4" face="궁서체">>>
                    자동차 대여이용 <%if(rent_end_dt.equals("")){%>연장<%}%> 계약서 <<
                </font>
                </center>
					</td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>			
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="15%" class=title>차량번호</td>
                  <td colspan="3">&nbsp;<input name="car_no" type="text" class="whitetext" value="<%=reserv.get("CAR_NO")%>" size="15"></td>
                </tr>
                <tr>
                  <td width="15%" class=title>차명</td>
                  <td colspan="3">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
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
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>        
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="15%" class=title>구분</td>
                  <td colspan="3">&nbsp;<%if(client.getClient_st().equals("1")) 	out.println("법인");
                      	else if(client.getClient_st().equals("2"))  			out.println("개인");
                      	else if(client.getClient_st().equals("3")) 			out.println("개인사업자(일반과세)");
                      	else if(client.getClient_st().equals("4"))			out.println("개인사업자(간이과세)");
                      	else if(client.getClient_st().equals("5")) 			out.println("개인사업자(면세사업자)");%></td>
                </tr>
                <%if(!client.getClient_st().equals("2")){%>
                <tr> 
                    <td width="15%" class=title>상호
        			</td>
                    <td colspan="3">&nbsp; <%=client.getFirm_nm()%></td>
                </tr>
                <%}%>
                <tr> 
                    <td width="15%" class=title>성명</td>
                    <td colspan="3">&nbsp;<%=client.getClient_nm()%></td>
                </tr>
                <tr> 
                    <td width="15%" class=title>사업자번호</td>
                    <td width="35%">&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
                    <td width="15%" class=title><%if(client.getClient_st().equals("1")){%>법인번호<%}else if(client.getClient_st().equals("2")){%>생년월일<%}else{%>생년월일<%}%></td>
                    <td width="35%">&nbsp;<%=client.getSsn1()%><%if(client.getClient_st().equals("1")){%>-<%=client.getSsn2()%><%}%></td>
                </tr>
                <tr> 
                    <td width="15%" class=title>주소</td>
                    <td colspan="3"> 
                        &nbsp;<%if(!client.getO_addr().equals("")){%>
    		              ( 
    		              <%}%>
    		              <%=client.getO_zip()%> 
    		              <%if(!client.getO_addr().equals("")){%>
    		              )&nbsp; 
    		              <%}%>
    		              <%=client.getO_addr()%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr><td class=h></td></tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약정보</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=13%>용도/관리</td>
                    <td width=20%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%>
			&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%>
		    </td>
                    <td class=title width=13%>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
            </table>
	    </td>
    </tr>
    <%	String r_rent_end_dt = ""; 
    	String r_im_seq = ""; 
    %>	
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="<%=im_cont_size+2%>"><%if(rent_end_dt.equals("")){%>최<br>종<br><%}%>계<br>약<br></td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">계약일자</td>
                    <!--<td style="font-size : 8pt;" width="6%" class=title rowspan="2">이용기간</td>-->
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">대여개시일</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">대여만료일</td>
                    <td style="font-size : 8pt;" width="7%" class=title rowspan="2">계약담당</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">월대여료</td>
                    <td style="font-size : 8pt;" class=title colspan="2">보증금</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">선납금</td>
                    <td style="font-size : 8pt;" class=title colspan="2">개시대여료</td>
                    <td style="font-size : 8pt;" class=title colspan="2">매입옵션</td>
                </tr>
                <tr>
                    <td style="font-size : 8pt;" width="10%" class=title>금액</td>
                    <td style="font-size : 8pt;" width="3%" class=title>승계</td>
                    <td style="font-size : 8pt;" width="10%" class=title>금액</td>
                    <td style="font-size : 8pt;" width="3%" class=title>승계</td>
                    <td style="font-size : 8pt;" width="10%" class=title>금액</td>
                    <td style="font-size : 8pt;" width="3%" class=title>%</td>			
                </tr>
    		<% 	for(int i = 0 ; i < im_cont_size ; i++){
				Hashtable ht = (Hashtable)im_cont.elementAt(i); 
				r_rent_end_dt = String.valueOf(ht.get("RENT_END_DT"));
		%>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2((String)ht.get("RENT_DT"))%></td>
                    <!--<td style="font-size : 8pt;" align="center"><%=ht.get("CON_MON")%>개월</td>-->
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2((String)ht.get("RENT_START_DT"))%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2((String)ht.get("RENT_END_DT"))%></td>
                    <td style="font-size : 8pt;" align="center"><%if(ht.get("RENT_ST").equals("1")){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById((String)ht.get("EXT_AGNT"),"USER")%><%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("FEE_S_AMT")))+AddUtil.parseInt(String.valueOf(ht.get("FEE_V_AMT"))))%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("GRT_AMT_S"))))%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(ht.get("GRT_SUC_YN").equals("0")){%>승계<%}else if(ht.get("GRT_SUC_YN").equals("1")){%>별도<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("PP_S_AMT")))+AddUtil.parseInt(String.valueOf(ht.get("PP_V_AMT"))))%>원&nbsp;</td>			
                    <td style="font-size : 8pt;" align="right"><%if(AddUtil.parseInt(String.valueOf(ht.get("IFEE_S_AMT")))>0){%><%if(AddUtil.parseInt(String.valueOf(ht.get("PERE_R_MTH")))>0){%><%=ht.get("PERE_R_MTH")%><%}else{%><%=AddUtil.parseInt(String.valueOf(ht.get("IFEE_S_AMT")))/AddUtil.parseInt(String.valueOf(ht.get("FEE_S_AMT")))%><%}%>회&nbsp;<%}%><%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("IFEE_S_AMT")))+AddUtil.parseInt(String.valueOf(ht.get("IFEE_V_AMT"))))%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(ht.get("IFEE_SUC_YN").equals("0")){%>승계<%}else if(ht.get("IFEE_SUC_YN").equals("1")){%>별도<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("OPT_S_AMT")))+AddUtil.parseInt(String.valueOf(ht.get("OPT_V_AMT"))))%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%=ht.get("OPT_PER")%></td>
                </tr>
		<%	}%>
            </table>
	    </td>
	</tr>
    
    <%if(imvt_size>0){%>
   <tr>
       <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>임의연장</span></td>	
    </tr>	  	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		    <td class="title" width="">연번</td>
		    <td class="title" width="">연장회차</td>
		    <td class="title" width="">연장대여기간</td>
		</tr>
		<% 	for(int i = 0 ; i < imvt_size ; i++){
				Hashtable imh = (Hashtable)imvt.elementAt(i);
				if(i==0){
					imh_stdt = (String)imh.get("RENT_START_DT");
				}
				r_rent_end_dt = String.valueOf(imh.get("RENT_END_DT"));
				r_im_seq      = String.valueOf(imh.get("IM_SEQ"));
		%>	
		<tr>
		    <td align="center"><%=i+1%></td>
		    <td align="center">&nbsp;<input type='text' size='3' name='add_tm' value='<%=imh.get("IM_SEQ")%>' maxlength='2' class='whitetext'>회</td>
		    <td align="center">&nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2((String)imh.get("RENT_START_DT"))%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
			~&nbsp;&nbsp;&nbsp;&nbsp;
			<input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2((String)imh.get("RENT_END_DT"))%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
		    </td>
		</tr>
		<%	}%>	
	        <%	if(cr_bean.getPrepare().equals("9") && AddUtil.parseInt(AddUtil.replace(r_rent_end_dt,"-","")) < AddUtil.parseInt(AddUtil.replace(doc_dt,"-",""))){%>
		<tr>
		    <td align="center"><%=imvt_size%></td>
		    <td align="center">&nbsp;<input type='text' size='3' name='add_tm' value='<%=AddUtil.parseInt(r_im_seq)+1%>' maxlength='2' class='whitetext'>회</td>
		    <td align="center">&nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2(c_db.addDay(r_rent_end_dt, 1))%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
			~&nbsp;&nbsp;&nbsp;&nbsp;
			<input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2(c_db.addMonth(doc_dt, 1))%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
		    </td>
		</tr>	
        	<%	}%>
	    </table>
	</td>
    </tr>	
    <%}else{%>	
        <%if(cr_bean.getPrepare().equals("9") && AddUtil.parseInt(AddUtil.replace(r_rent_end_dt,"-","")) < AddUtil.parseInt(AddUtil.replace(doc_dt,"-",""))){%>
   <tr>
       <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>임의연장</span></td>	
    </tr>	  	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		    <td class="title" width="">연번</td>
		    <td class="title" width="">연장회차</td>
		    <td class="title" width="">연장대여기간</td>
		</tr>
		<tr>
		    <td align="center">1</td>
		    <td align="center">&nbsp;<input type='text' size='3' name='add_tm' value='1' maxlength='2' class='whitetext'>회</td>
		    <td align="center">&nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2(c_db.addDay(r_rent_end_dt, 1))%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
			~&nbsp;&nbsp;&nbsp;&nbsp;
			<input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2(c_db.addMonth(doc_dt, 1))%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
		    </td>
		</tr>	
	    </table>
	</td>
    </tr>		
        <%}%>
    <%}%>
	
	<tr>
		<td height=15></td>
	</tr>
	
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;위 고객에게 <%=reserv.get("CAR_NO")%> <b><%=reserv.get("CAR_NM")%></b> 차량을 장기계약 대여기간 및 임의 연장 기간을 포함하여 <br>
    	<input type='text' name='rent_start_dt2' value='<%=AddUtil.ChangeDate2((String)fee_im.get("MIN_SDT"))%>' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> ~ 
    	<%if(cr_bean.getPrepare().equals("9") && AddUtil.parseInt(AddUtil.replace(r_rent_end_dt,"-","")) < AddUtil.parseInt(AddUtil.replace(doc_dt,"-",""))){%>
    	<input type='text' name='rent_end_dt2' value='<%=AddUtil.ChangeDate2(c_db.addMonth(doc_dt, 1))%>' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> 까지
    	<%}else{%>
    	<input type='text' name='rent_end_dt2' value='<%=AddUtil.ChangeDate2((String)fee_im.get("MAX_EDT"))%>' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> 까지
    	<%}%>
    	   제공 하였슴을 증명함.
    	</td>
    </tr>
	
	<tr>
		<td align=right><img src=/acar/images/pay_h_ceo.gif></td>
	</tr>        	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
