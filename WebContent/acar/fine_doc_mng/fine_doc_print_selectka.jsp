<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.fee.*, acar.res_search.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
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
<script>

window.onbeforeprint = function(){
	//setCookie();
};

function setCookie(cName, cValue, cMinutes){

 	var expire = new Date();
    expire.setDate(expire.getMinutes() + cMinutes);
    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr';
    if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
    document.cookie = cookies;
    
}

// 쿠키 가져오기
function getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if(start != -1){
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}

setCookie('tmp_waste', 'delete', 1);

</script>
</head>
<body leftmargin="15" topmargin="1">
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 

	
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	
	String doc_id 	= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String doc_dt 	= "";
	int start_num 	= request.getParameter("start_num")==null?0:AddUtil.parseInt(request.getParameter("start_num"));
	int end_num 	= request.getParameter("end_num")==null?0:AddUtil.parseInt(request.getParameter("end_num"));
	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
		
	double img_width 	= 680;
	double img_height 	= 1009;

	//과태료공문
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	doc_dt = FineDocBn.getDoc_dt();
	
	//과태료리스트
	Vector FineList = FineDocDb.getFineDocLists(doc_id);

	
%>

<form action="" name="form1" method="POST" >

<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>

<%for(int k=start_num-1; k<end_num; k++){ 

	FineDocListBn = (FineDocListBean)FineList.elementAt(k);
			
        String rent_mng_id 	= FineDocListBn.getRent_mng_id();
	String rent_l_cd 	= FineDocListBn.getRent_l_cd();
	String client_id 	= FineDocListBn.getClient_id();
	String rent_s_cd 	= FineDocListBn.getRent_s_cd();
	String car_mng_id	= FineDocListBn.getCar_mng_id();
	String rent_st		= FineDocListBn.getRent_st();						
	String vio_dt		= FineDocListBn.getVio_dt();
			
	Hashtable ff = FineDocDb.getFind_file6(doc_id, rent_mng_id, rent_l_cd, client_id, vio_dt);
			
	if(FineDocListBn.getClient_id().equals("000228") && !FineDocListBn.getRent_s_cd().equals("")){
		client_id = (String)ff.get("CUST_ID");
	}
			
	Vector fs = FineDocDb.getFind_scan(rent_mng_id, rent_l_cd, client_id, rent_s_cd);
	int fs_size = fs.size();
%>

    <%if(!ff.get("FILE_NAME").equals("")){%>
    <tr valign="top">
	<td>
	    <img src="https://fms3.amazoncar.co.kr<%=ff.get("SAVE_FOLDER")%><%=ff.get("SAVE_FILE")%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
	</td>
    </tr>
    <%}%>
        
<%

	String im_seq	 	= request.getParameter("im_seq")==null?"":request.getParameter("im_seq");		
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	//ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
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
		
	String imh_stdt = "";
	Hashtable fee_im = af_db.getfee_minmax(rent_mng_id, rent_l_cd);
	
	//임의연장
	FeeImBean im = af_db.getFeeIm(rent_mng_id, rent_l_cd, "1", im_seq);
	
	//영업담당자
	user_bean 	= umd.getUsersBean(base.getBus_id());
	
	long total_amt 	= 0;
	
	/*2016-04-14 추가 gillsun */
	//임의연장
	Vector imvt = af_db.getFeeImList(rent_mng_id, rent_l_cd, rent_st);
	int imvt_size = imvt.size();
	/***********************/
	
	//계약전부
	Vector im_cont = af_db.im_rent_cont(rent_mng_id, rent_l_cd, rent_st);
	int im_cont_size = im_cont.size();
	
	String reg_dt = Util.getDate();
	
	String disabled = "disabled";
	String white = "white";
	String readonly = "readonly";
	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트
	int user_size = users.size();
	//보험사 리스트
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;	
	
	String c_id = base.getCar_mng_id();
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(rent_s_cd, base.getCar_mng_id());
	
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	
	
	//단기관리자-연대보증인
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(rent_s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(rent_s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(rent_s_cd, "3");
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(rent_s_cd, "4");
	
	
	String use_st = rc_bean.getUse_st();
	
	String print_car_no = "";
	String print_car_nm = "";
	
	

	
%>

<%if(rc_bean.getRent_st().equals("")){%>
<table border='0' cellspacing='0' cellpadding='0' width='650'  class="a4">
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
		    <td><center><font size="4" face="궁서체">>>
                        자동차 대여이용 <%if(!im.getAdd_tm().equals("")){%>연장<%}%> 계약서 <<
                        </font></center>
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
                    <td colspan="3">&nbsp;<%if(client.getClient_st().equals("1")){ 	out.println("법인");
                   	 	}else if(client.getClient_st().equals("2")){  			out.println("개인");
						}else if(client.getClient_st().equals("3")){ 			out.println("개인사업자(일반과세)");
						}else if(client.getClient_st().equals("4")){			out.println("개인사업자(간이과세)");
						}else if(client.getClient_st().equals("5")){ 			out.println("개인사업자(면세사업자)");%>}</td>
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
                    <td width="15%" class=title><%if(client.getClient_st().equals("1")){%>법인번호<%}else{%>주민번호<%}%></td>
                    <td width="35%">&nbsp;<%=client.getSsn1()%>-<%if(client.getClient_st().equals("1")){%><%=client.getSsn2()%><%}else{%><%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******<%}%></td>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약정보(재계약포함)</span></td>
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
                    <td width=20%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}%>
			&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%>
		    </td>
                    <td class=title width=13%>최종영업담당자</td>
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
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="<%=Integer.toString(fee_size)+2%>">최<br>종<br>계<br>약<br></td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">계약일자</td>
                    <td style="font-size : 8pt;" width="6%" class=title rowspan="2">이용기간</td>
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
    		<% for(int i = 0 ; i < im_cont_size ; i++){
				Hashtable ht = (Hashtable)im_cont.elementAt(i); 
					
				r_rent_end_dt = String.valueOf(ht.get("RENT_END_DT"));
		%>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2((String)ht.get("RENT_DT"))%></td>
                    <td style="font-size : 8pt;" align="center"><%=ht.get("CON_MON")%>개월</td>
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
		<%}%>
            </table>
	</td>
    </tr>	
    <tr><td class=h></td></tr>
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
		<%for(int i = 0 ; i < imvt_size ; i++){
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
		<%}%>
		<%if(cr_bean.getPrepare().equals("9") && AddUtil.parseInt(AddUtil.replace(r_rent_end_dt,"-","")) < AddUtil.parseInt(AddUtil.replace(doc_dt,"-",""))){%>
		<tr>
		    <td align="center"><%=imvt_size%></td>
		    <td align="center">&nbsp;<input type='text' size='3' name='add_tm' value='<%=AddUtil.parseInt(r_im_seq)+1%>' maxlength='2' class='whitetext'>회</td>
		    <td align="center">&nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2(c_db.addDay(r_rent_end_dt, 1))%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
			~&nbsp;&nbsp;&nbsp;&nbsp;
			<input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2(c_db.addMonth(doc_dt, 1))%>' size='15' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
		    </td>
		</tr>	
        	<%}%>	
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
    <% ContFeeBean fees = ext_fee;%>
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;위 고객에게 <%=reserv.get("CAR_NO")%> <b><%=reserv.get("CAR_NM")%></b> 차량을 
	    장기계약 대여기간 및 임의 연장 기간을 포함하여 	    
	    <input type='text' name='rent_start_dt2' value='<%=AddUtil.ChangeDate2((String)fee_im.get("MIN_SDT"))%>' size='10' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> ~ 
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

<%}else if(!rc_bean.getRent_st().equals("")){%>
<table border=0 cellspacing=0 cellpadding=0 width=650>
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
    <tr id=tr_cust_nm style='display:<%if(rc_bean.getRent_st().equals("1")||rc_bean.getRent_st().equals("2")||rc_bean.getRent_st().equals("3")||rc_bean.getRent_st().equals("4")||rc_bean.getRent_st().equals("5")||rc_bean.getRent_st().equals("9")||rc_bean.getRent_st().equals("10")||rc_bean.getRent_st().equals("12")) {%>block <%}else{%>none <%}%>'> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>
        <td align="right"><a href='javascript:save();'></a></td>
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
                    <td width="15%" class=title>상호
        			</td>
                    <td width="35%">&nbsp; <%=rc_bean2.getFirm_nm()%>  
                    </td>
                    <td width="15%" class=title>성명</td>
                    <td width="35%">&nbsp;<%=rc_bean2.getCust_nm()%>                    </td>
                </tr>
                <tr> 
                    <td width="15%" class=title>사업자번호</td>
                    <td width="35%">&nbsp;<%=rc_bean2.getEnp_no()%> </td>
                    <td width="15%" class=title><%if(rc_bean2.getCust_st().equals("개인")) {%>주민 <%}else{%>법인 <%}%>번호</td>
                    <td width="35%">&nbsp;<%if(rc_bean2.getCust_st().equals("개인")){%>
                  <%=AddUtil.subData((String)rc_bean2.getSsn(),6)%>-<%if(rc_bean2.getSsn().length() > 6){%><%=rc_bean2.getSsn().substring(6,7)%><%}%>******
                    <%}else{%>
                    <%=rc_bean2.getSsn()%>
                    <%}%>                    </td>
                </tr>
                <tr> 
                    <td width="15%" class=title>주소</td>
                    <td colspan="3"> 
                        &nbsp;<%=rc_bean2.getZip()%>
                        &nbsp; 
                        <%=rc_bean2.getAddr()%>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=15%>면허번호</td>
                    <td> 
                        &nbsp;<%=rm_bean4.getLic_no()%>
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
                <td width="15%" class=title><%if(rc_bean2.getCust_st().equals("개인")){%>
                  주민
                    <%}else{%>
                    법인
                    <%}%>
                번호</td>
                <td width="35%">&nbsp;<%if(rc_bean2.getCust_st().equals("개인")){%>
                  <%=AddUtil.subData((String)rc_bean2.getSsn(),6)%>-<%if(rc_bean2.getSsn().length() > 6){%><%=rc_bean2.getSsn().substring(6,1)%><%}%>******
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
    <input type='hidden' name='c_zip' value=''>				
    <input type='hidden' name='c_addr' value=''>	
    <input type='hidden' name='c_lic_no' value=''>				
    <input type='hidden' name='c_lic_st' value=''>	
    <input type='hidden' name='c_tel' value=''>				
    <input type='hidden' name='c_m_tel' value=''>		
    <%}else if(rc_bean.getRent_st().equals("4") || rc_bean.getRent_st().equals("5")){%>
    <input type='hidden' name='c_firm_nm' value='(주)아마존카'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>구분</td>
                    <td width=35%> 
                        &nbsp;아마존카 직원
                    </td>
                    <td class=title width=15%>성명</td>
                    <td width=35%> 
                        &nbsp;<select name='c_cust_nm' onChange='javascript:user_select()' <%=disabled%>>
                            <option value="">==선택==</option>			  
                            <%	if(user_size > 0){
            						for (int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                            <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean2.getCust_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                            <%		}
            					}		%>
                        </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}else{%>
    <input type='hidden' name='c_cust_st' value='5'>	
    <input type='hidden' name='c_cust_nm' value=''>
    <input type='hidden' name='c_firm_nm' value=''>	
    <input type='hidden' name='c_ssn' value=''>
    <input type='hidden' name='c_enp_no' value=''>
    <input type='hidden' name='c_lic_no' value=''>				
    <input type='hidden' name='c_lic_st' value=''>
    <input type='hidden' name='c_zip' value=''>				
    <input type='hidden' name='c_addr' value=''>	
	<%}%>
    <tr><td class=h></td></tr>
	<%if(rc_bean.getRent_st().equals("10")){
		//지연대차정보
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
                  <td width="35%">&nbsp;
				  <%=print_car_no%></td>
                  <td width="15%" class=title>차종</td>
                  <td width="35%">&nbsp;
                  <%=print_car_nm%></td>
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
                    <td colspan="3"> 
                        &nbsp;
						<%=serv.get("OFF_NM")==null?"":serv.get("OFF_NM")%>
                    </td>
                </tr>
                <tr>
                  <td width="15%" class=title style='height:38'>정비차량번호</td>
                  <td width="35%">&nbsp;
				  <%=serv.get("CAR_NO")==null?"":serv.get("CAR_NO")%></td>
                  <td width="15%" class=title>차종</td>
                  <td width="35%">&nbsp;
                  <%=serv.get("CAR_NM")==null?"":serv.get("CAR_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>	
	<%}else if(rc_bean.getRent_st().equals("3")){
		//사고대차정보
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());
		String seq_no = request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
		//if(mode.equals("accid_doc") && !seq_no.equals("")) 
		accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id(), seq_no);%>
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
                  <td colspan="3">&nbsp;
				  <input name="off_nm" type="text" class="whitetext" value="<%=accid.get("OFF_NM")==null?"":accid.get("OFF_NM")%>" size="80"></td>
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
		RentInsBean ri_bean = rs_db.getRentInsCase(rent_s_cd);%>
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
                    <td width="30%"> 
                      &nbsp;<select name='ins_com_id' <%=disabled%>>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ri_bean.getIns_com_id().equals(ic.getIns_com_id())){%>selected<%}%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width="10%" class=title> 담당자</td>
                    <td width="15%">&nbsp;
                        <%=ri_bean.getIns_nm()%>
                    </td>
                </tr>
                <tr>
                  <td width="15%" class=title>연락처Ⅰ</td>
                  <td>&nbsp;
                      <%=ri_bean.getIns_tel()%>
                  </td>
                  <td width="10%" class=title>연락처Ⅱ</td>
                  <td>&nbsp;
                      <%=ri_bean.getIns_tel2()%>
                  </td>
                  <td width="10%" class=title>팩스</td>
                  <td>&nbsp;
                      <%=ri_bean.getIns_fax()%>
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
                    <td class=title width=15% style='height:37'>
        			정비공장</td>
                    <td width=35%> 
                      &nbsp;<%=accid.get("OFF_NM")%>
                  </td>
                    <td class=title width=10%>사고일자</td>
                    <td width=20%> 
                      &nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%>
                  </td>
                    <td class=title width=10%>담당자</td>
                    <td width=10%> 
                      &nbsp;<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%>
                  </td>
                </tr>
                <tr> 
                    <td width="15%" class=title> 사고내용</td>
                    <td colspan="5"> 
                      &nbsp;<%=accid.get("ACCID_CONT")%>&nbsp;<%=accid.get("ACCID_CONT2")%>
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
                    <td width=20%>&nbsp;
					  <%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
                    <td class=title width=10%>영업소</td>
                    <td width=25%>&nbsp;
                      <%=c_db.getNameById(rc_bean.getBrch_id(),"BRCH")%>                    
                    </td>
                    <td width=10% class=title>담당자</td>
                    <td width="20%">&nbsp;
                      <%=c_db.getNameById(rc_bean.getBus_id(),"USER")%>                      
                    </td>
                </tr>
                <tr> 
                    <td class=title>기타</td>
                    <td colspan="5"> 
                      &nbsp;<%=rc_bean.getEtc()%>
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
                    <td width="35%"> 
                      &nbsp;<%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%>
                    </td>
                    <td width="15%" class=title>반차예정일</td>
                    <td width="35%"> 
                      &nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=15%>배차일자</td>
                    <td width=35%> 
                      &nbsp;<%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%>
                    </td>
                    <td class=title width=15%>반차일자</td>
                    <td width=35%>
                      &nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%>
        			</td>
                </tr>
                <tr> 
                    <td width="15%" class=title>배차위치</td>
                    <td width="35%"> 
                      &nbsp;<%=rc_bean.getDeli_loc()%>
                    </td>
                    <td width="15%" class=title>반차위치</td>
                    <td width="35%">
					  &nbsp;<%=rc_bean.getRet_loc()%>
					</td>
                </tr>
          </table>
        </td>
    </tr>
<!-- 사고대차 화면 출력 양식 요청해서 임시로 작업함. 2009-05-08 여기서 부터-->    
	<tr>
		<td height=15></td>
	</tr>
	<%{
			Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());
			
			if(print_car_no.equals("")){
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
    <%}%>
	<tr>
		<td align=right><img src=/acar/images/pay_h_ceo.gif></td>
	</tr>    
<!-- 여기까지 -->	
   
</table>
<%}%>

<%
			String content_code = "LC_SCAN";
	String content_seq = "";
	int size = 0;
	

				for(int i = 0 ; i < fs_size ; i++){
					Hashtable ht = (Hashtable)fs.elementAt(i); 
					
			//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------

			 content_code = "LC_SCAN";
			 content_seq  = (String)ht.get("RENT_MNG_ID")+(String)ht.get("RENT_L_CD")+(String)ht.get("RENT_ST")+17;

			Vector attach_vt = c_db.getAcarAttachFileList_fine(content_code, content_seq, 0);		
			int attach_vt_size = attach_vt.size();

			for(int j=0; j< 1; j++){
				Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
				
			
%>
	<tr valign="top">
		<td>
			<img src="https://fms3.amazoncar.co.kr<%=aht.get("SAVE_FOLDER")%><%=aht.get("SAVE_FILE")%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
		</td>
	</tr>
<%					
					
				}
			}	

	%>



</table>	


</form>
</body>
</html>
<script>
onprint();

//5초후에 인쇄박스 팝업
//setTimeout(onprint_box,5000);


function onprint(){
	factory.printing.header 	= ""; //폐이지상단 인쇄
	factory.printing.footer 	= ""; //폐이지하단 인쇄
	factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
	factory.printing.leftMargin 	= 10.0; //좌측여백   
	factory.printing.rightMargin 	= 10.0; //우측여백
	factory.printing.topMargin 	= 10.0; //상단여백    
	factory.printing.bottomMargin 	= 10.0; //하단여백
}
function onprint_box(){
	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>
