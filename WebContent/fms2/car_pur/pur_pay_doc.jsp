<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.doc_settle.*, acar.fee.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String pur_est_dt = AddUtil.getDate();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = new Vector();
	
	if(!doc_no.equals("")){
		vt = d_db.getCarPurPayDocList("99", doc_no, "", "", "", "", "");
	}
	int vt_size = vt.size();
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	if(doc_no.equals("")){
		user_bean 	= umd.getUsersBean(user_id);
	}
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;
	long total_amt16 = 0;
	long total_amt17 = 0;
	long total_amt18 = 0;
	long total_amt19 = 0;
	long total_amt20 = 0;
	long total_amt21 = 0;
	long total_amt22 = 0;
	long total_amt23 = 0;
	long total_amt24 = 0;
	
	int s1 = 0;
	int b1 = 0;
	int d1 = 0;
	int s2 = 0;
	int j1 = 0;
	int g1 = 0;
	int i1 = 0;
	int k3 = 0;
	int s3 = 0;
	int s4 = 0;
	int u1 = 0;
	int s5 = 0;
	int s6 = 0;

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//리스트
	function list(){
		var fm = document.form1;		
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'pur_pay_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='pur_pay_doc_sanction.jsp';		
//			fm.target='i_no';
			fm.submit();
		}									
	}
	
	function doc_cancel(rent_mng_id, rent_l_cd){
		var fm = document.form1;
		fm.c_rent_mng_id.value = rent_mng_id;
		fm.c_rent_l_cd.value = rent_l_cd;
		
		if(confirm('취소하시겠습니까?')){	
			if(confirm('진짜로 취소하시겠습니까? 기안전으로 넘어갑니다.')){	
				fm.action='pur_pay_doc_end_after_cancel.jsp';		
//				fm.target='i_no';
				fm.submit();
			}	
		}									
	}	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='doc_no' 	value='<%=doc_no%>'>
  <input type='hidden' name='doc_bit' 	value=''>  
  <input type='hidden' name='c_rent_mng_id' 	value=''>  
  <input type='hidden' name='c_rent_l_cd' 	value=''>      


<table border="0" cellspacing="0" cellpadding="0" width=2910>
    <tr>
        <td><< 지출계획 >></td>
    </tr>  
    <tr>
        <td>&nbsp;<%if(mode.equals("doc_settle")){%><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a><%}%></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='2910'>
		        <tr>
        			<td width='30' rowspan='2' class='title'>연번</td>
        		    <td width='100' rowspan='2' class='title'>계약번호</td>
        		    <td width="200" rowspan='2' class='title'>계약자명</td>
        		    <td width="60" rowspan='2' class='title'>최초영업</td>					
               		<td width='100' rowspan='2' class='title'>차종</td>					
               		<td width='110' rowspan='2' class='title'>출고예정일</td>
               		<td width='40' rowspan='2' class='title'>과세<br>구분</td>
               		<td width='100' rowspan='2' class='title'>지출처</td>
        			<td colspan="3" class='title'>구입가격</td>					
        			<td colspan="3" class='title'>선수금</td>					
        		    <td width="80" rowspan='2' class='title'>계약금</td>	
        		    <td colspan="3" class='title'>임시운행보험료</td>				  							
        			<td colspan="3" class='title'>지출처리예정내역1</td>				  
        			<td colspan="3" class='title'>지출처리예정내역2</td>
        			<td colspan="3" class='title'>지출처리예정내역3</td>
        			<td colspan="3" class='title'>지출처리예정내역4</td>
               		<td width='100' rowspan='2' class='title'>합계</td>					
               		<td width='100' rowspan='2' class='title'>지출예정일</td>									  				  			
		        </tr>
		        <tr>
        			<td width='90' class='title'>소비자가</td>				  				  
        			<td width='90' class='title'>D/C금액</td>
        			<td width='90' class='title'>구입가격</td>
        			<td width='90' class='title'>보증금</td>				  				  
        			<td width='90' class='title'>선납/<br>개시대여료</td>
        			<td width='90' class='title'>합계</td>
        			<td width='90' class='title'>지급수단</td>
        			<td width='90' class='title'>카드종류</td>				  
        			<td width='90' class='title'>금액</td>
        			<td width='90' class='title'>지급수단</td>
        			<td width='90' class='title'>카드종류</td>				  
        			<td width='90' class='title'>금액</td>
        			<td width='90' class='title'>지급수단</td>
        			<td width='90' class='title'>카드종류</td>				  
        			<td width='90' class='title'>금액</td>
        			<td width='90' class='title'>지급수단</td>
        			<td width='90' class='title'>카드종류</td>				  
        			<td width='90' class='title'>금액</td>
        			<td width='90' class='title'>지급수단</td>
        			<td width='90' class='title'>카드종류</td>				  
        			<td width='90' class='title'>금액</td>
		        </tr>		
		  <%if(doc_no.equals("")){
				String vid[] = request.getParameterValues("ch_cd");
				String rent_l_cd = "";
				vt_size = vid.length;
				for(int i=0;i < vt_size;i++){
					rent_l_cd = vid[i];
					Hashtable ht = d_db.getCarPurPayDocCase(rent_l_cd);
		  %>
		        <tr>
        			<td align='center'><%=i+1%></td>
        		    <td align='center'><%=ht.get("RENT_L_CD")%><input type='hidden' name='rent_mng_id' value='<%=ht.get("RENT_MNG_ID")%>'><input type='hidden' name='rent_l_cd' value='<%=ht.get("RENT_L_CD")%>'></td>
        		    <td align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
        		    <td align='center'><%=ht.get("USER_NM")%></td>					
               		<td align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>					
               		<td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("DLV_EST_DT")))%></td>
               		<td align='center'><%=ht.get("PURC_GU")%></td>
               		<td align='center'><span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 6)%></span></td>
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%></td>				  				  
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_DC_AMT")))%></td>
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("GRT_AMT_S")))%></td>
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("PP_IFEE_AMT")))%></td>
        			<td align='right'><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT_S")))+AddUtil.parseLong(String.valueOf(ht.get("PP_IFEE_AMT"))))%></td>
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CON_AMT")))%></td>			
        			<td align='center'><%=ht.get("TRF_ST5")%></td>
        			<td align='center'><%=ht.get("CARD_KIND5")%></td>				  
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT5")))%></td>
        			<td align='center'><%=ht.get("TRF_ST1")%></td>
        			<td align='center'><%=ht.get("CARD_KIND1")%></td>				  
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT1")))%></td>
        			<td align='center'><%=ht.get("TRF_ST2")%></td>
        			<td align='center'><%=ht.get("CARD_KIND2")%></td>				  
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT2")))%></td>
        			<td align='center'><%=ht.get("TRF_ST3")%></td>
        			<td align='center'><%=ht.get("CARD_KIND3")%></td>				  
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT3")))%></td>
        			<td align='center'><%=ht.get("TRF_ST4")%></td>
        			<td align='center'><%=ht.get("CARD_KIND4")%></td>				  
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT4")))%></td>
               		<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%></td>					
               		<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_EST_DT")))%></td>									  				  			
		        </tr>
		        
		  <%		total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CAR_C_AMT")));
					total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("CAR_DC_AMT")));
					total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("CAR_F_AMT")));
					total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					total_amt8 	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));
					total_amt13 = total_amt13 + AddUtil.parseLong(String.valueOf(ht.get("CON_AMT")));
					total_amt23 = total_amt23 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT5")));
					
					if(String.valueOf(ht.get("TRF_ST1")).equals("현금")) 		total_amt9  = total_amt9  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					if(String.valueOf(ht.get("TRF_ST1")).equals("선불카드")) 	total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					if(String.valueOf(ht.get("TRF_ST1")).equals("후불카드")) 	total_amt11 = total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					if(String.valueOf(ht.get("TRF_ST1")).equals("대출")) 		total_amt20 = total_amt20 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					if(String.valueOf(ht.get("TRF_ST1")).equals("포인트")) 	total_amt21 = total_amt21 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					if(String.valueOf(ht.get("TRF_ST1")).equals("구매보조금")) total_amt22 = total_amt22 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					if(String.valueOf(ht.get("TRF_ST1")).equals("카드할부"))  	total_amt24 = total_amt24 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					
					if(String.valueOf(ht.get("TRF_ST2")).equals("현금")) 		total_amt9  = total_amt9  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					if(String.valueOf(ht.get("TRF_ST2")).equals("선불카드")) 	total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					if(String.valueOf(ht.get("TRF_ST2")).equals("후불카드")) 	total_amt11 = total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					if(String.valueOf(ht.get("TRF_ST2")).equals("대출")) 		total_amt20 = total_amt20 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					if(String.valueOf(ht.get("TRF_ST2")).equals("포인트")) 	total_amt21 = total_amt21 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					if(String.valueOf(ht.get("TRF_ST2")).equals("구매보조금")) total_amt22 = total_amt22 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					if(String.valueOf(ht.get("TRF_ST2")).equals("카드할부"))  	total_amt24 = total_amt24 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					
					if(String.valueOf(ht.get("TRF_ST3")).equals("현금")) 		total_amt9  = total_amt9  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					if(String.valueOf(ht.get("TRF_ST3")).equals("선불카드")) 	total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					if(String.valueOf(ht.get("TRF_ST3")).equals("후불카드")) 	total_amt11 = total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					if(String.valueOf(ht.get("TRF_ST3")).equals("대출")) 		total_amt20 = total_amt20 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					if(String.valueOf(ht.get("TRF_ST3")).equals("포인트")) 	total_amt21 = total_amt21 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					if(String.valueOf(ht.get("TRF_ST3")).equals("구매보조금")) total_amt22 = total_amt22 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					if(String.valueOf(ht.get("TRF_ST3")).equals("카드할부"))  	total_amt24 = total_amt24 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					
					if(String.valueOf(ht.get("TRF_ST4")).equals("현금")) 		total_amt9  = total_amt9  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					if(String.valueOf(ht.get("TRF_ST4")).equals("선불카드")) 	total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					if(String.valueOf(ht.get("TRF_ST4")).equals("후불카드")) 	total_amt11 = total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					if(String.valueOf(ht.get("TRF_ST4")).equals("대출")) 		total_amt20 = total_amt20 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					if(String.valueOf(ht.get("TRF_ST4")).equals("포인트")) 	total_amt21 = total_amt21 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					if(String.valueOf(ht.get("TRF_ST4")).equals("구매보조금")) total_amt22 = total_amt22 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					if(String.valueOf(ht.get("TRF_ST4")).equals("카드할부"))  	total_amt24 = total_amt24 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					
					if(String.valueOf(ht.get("TRF_ST5")).equals("현금")) 		total_amt9  = total_amt9  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT5")));
					if(String.valueOf(ht.get("TRF_ST5")).equals("선불카드")) 	total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT5")));
					if(String.valueOf(ht.get("TRF_ST5")).equals("후불카드")) 	total_amt11 = total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT5")));
					
					total_amt17 	= total_amt17 + AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT_S")));
					total_amt18 	= total_amt18 + AddUtil.parseLong(String.valueOf(ht.get("PP_IFEE_AMT")));
					total_amt19	= total_amt19 + AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT_S"))) + AddUtil.parseLong(String.valueOf(ht.get("PP_IFEE_AMT")));
		 		}%>
		  <%}else{
			  	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
			  		if(i==0) pur_est_dt = AddUtil.ChangeDate3(String.valueOf(ht.get("PUR_EST_DT")));
					
					if(String.valueOf(ht.get("BR_ID")).equals("S1")) s1++;
					if(String.valueOf(ht.get("BR_ID")).equals("B1")) b1++;
					if(String.valueOf(ht.get("BR_ID")).equals("D1")) d1++;
					if(String.valueOf(ht.get("BR_ID")).equals("S2")) s2++;
					if(String.valueOf(ht.get("BR_ID")).equals("J1")) j1++;
					if(String.valueOf(ht.get("BR_ID")).equals("G1")) g1++;
					if(String.valueOf(ht.get("BR_ID")).equals("I1")) i1++;
					if(String.valueOf(ht.get("BR_ID")).equals("K3")) k3++;
					if(String.valueOf(ht.get("BR_ID")).equals("S3")) s3++;
					if(String.valueOf(ht.get("BR_ID")).equals("S4")) s4++;
					if(String.valueOf(ht.get("BR_ID")).equals("U1")) u1++;
					if(String.valueOf(ht.get("BR_ID")).equals("S5")) s5++;
					if(String.valueOf(ht.get("BR_ID")).equals("S6")) s6++;
		  %>
		        <tr>
        			<td align='center'><%=i+1%></td>
        		    <td align='center'><%=ht.get("RENT_L_CD")%><input type='hidden' name='rent_mng_id' value='<%=ht.get("RENT_MNG_ID")%>'><input type='hidden' name='rent_l_cd' value='<%=ht.get("RENT_L_CD")%>'></td>
        		    <td align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 15)%></span>
					  <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("영업수당관리자",user_id) || nm_db.getWorkAuthUser("대출관리자",user_id)){%><a href="javascript:doc_cancel('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>');">[D]</a><%}%>
					</td>
        		    <td align='center'><%=ht.get("USER_NM")%></td>					
               		<td align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>					
               		<td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("DLV_EST_DT")))%></td>
               		<td align='center'><%=ht.get("PURC_GU")%></td>
               		<td align='center'><span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 6)%></span></td>
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%></td>				  				  
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_DC_AMT")))%></td>
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("GRT_AMT_S")))%></td>
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("PP_IFEE_AMT")))%></td>
        			<td align='right'><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT_S")))+AddUtil.parseLong(String.valueOf(ht.get("PP_IFEE_AMT"))))%></td>        			
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CON_AMT")))%></td>			
        			<td align='center'><%=ht.get("TRF_ST5")%></td>
        			<td align='center'><span title='<%=ht.get("CARD_KIND5")%>'><%=Util.subData(String.valueOf(ht.get("CARD_KIND5")), 5)%></span></td>
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT5")))%></td>
        			<td align='center'><%=ht.get("TRF_ST1")%></td>
        			<td align='center'><span title='<%=ht.get("CARD_KIND1")%>'><%=Util.subData(String.valueOf(ht.get("CARD_KIND1")), 5)%></span></td>				  
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT1")))%></td>
        			<td align='center'><%=ht.get("TRF_ST2")%></td>
        			<td align='center'><span title='<%=ht.get("CARD_KIND2")%>'><%=Util.subData(String.valueOf(ht.get("CARD_KIND2")), 5)%></span></td>				  
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT2")))%></td>
        			<td align='center'><%=ht.get("TRF_ST3")%></td>
        			<td align='center'><span title='<%=ht.get("CARD_KIND3")%>'><%=Util.subData(String.valueOf(ht.get("CARD_KIND3")), 5)%></span></td>				  
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT3")))%></td>
        			<td align='center'><%=ht.get("TRF_ST4")%></td>
        			<td align='center'><span title='<%=ht.get("CARD_KIND4")%>'><%=Util.subData(String.valueOf(ht.get("CARD_KIND4")), 5)%></span></td>				  
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT4")))%></td>
               		<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%></td>					
               		<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_EST_DT")))%></td>									  				  			
		        </tr>
		  <%		total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CAR_C_AMT")));
					total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("CAR_DC_AMT")));
					total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("CAR_F_AMT")));
					total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					total_amt8 	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));
					total_amt13 = total_amt13 + AddUtil.parseLong(String.valueOf(ht.get("CON_AMT")));
					total_amt23 = total_amt23 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT5")));
					
					if(String.valueOf(ht.get("TRF_ST1")).equals("현금")) 		total_amt9  = total_amt9  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					if(String.valueOf(ht.get("TRF_ST1")).equals("선불카드")) 	total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					if(String.valueOf(ht.get("TRF_ST1")).equals("후불카드")) 	total_amt11 = total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					if(String.valueOf(ht.get("TRF_ST1")).equals("대출")) 		total_amt20 = total_amt20 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					if(String.valueOf(ht.get("TRF_ST1")).equals("포인트")) 	total_amt21 = total_amt21 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					if(String.valueOf(ht.get("TRF_ST1")).equals("구매보조금")) total_amt22 = total_amt22 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					if(String.valueOf(ht.get("TRF_ST1")).equals("카드할부")) 	total_amt24 = total_amt24 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
					
					if(String.valueOf(ht.get("TRF_ST2")).equals("현금")) 		total_amt9  = total_amt9  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					if(String.valueOf(ht.get("TRF_ST2")).equals("선불카드")) 	total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					if(String.valueOf(ht.get("TRF_ST2")).equals("후불카드")) 	total_amt11 = total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					if(String.valueOf(ht.get("TRF_ST2")).equals("대출")) 		total_amt20 = total_amt20 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					if(String.valueOf(ht.get("TRF_ST2")).equals("포인트")) 	total_amt21 = total_amt21 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					if(String.valueOf(ht.get("TRF_ST2")).equals("구매보조금")) total_amt22 = total_amt22 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					if(String.valueOf(ht.get("TRF_ST2")).equals("카드할부")) 	total_amt24 = total_amt24 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
					
					if(String.valueOf(ht.get("TRF_ST3")).equals("현금")) 		total_amt9  = total_amt9  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					if(String.valueOf(ht.get("TRF_ST3")).equals("선불카드")) 	total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					if(String.valueOf(ht.get("TRF_ST3")).equals("후불카드")) 	total_amt11 = total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					if(String.valueOf(ht.get("TRF_ST3")).equals("대출")) 		total_amt20 = total_amt20 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					if(String.valueOf(ht.get("TRF_ST3")).equals("포인트")) 	total_amt21 = total_amt21 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					if(String.valueOf(ht.get("TRF_ST3")).equals("구매보조금")) total_amt22 = total_amt22 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					if(String.valueOf(ht.get("TRF_ST3")).equals("카드할부")) 	total_amt24 = total_amt24 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
					
					if(String.valueOf(ht.get("TRF_ST4")).equals("현금")) 		total_amt9  = total_amt9  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					if(String.valueOf(ht.get("TRF_ST4")).equals("선불카드")) 	total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					if(String.valueOf(ht.get("TRF_ST4")).equals("후불카드")) 	total_amt11 = total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					if(String.valueOf(ht.get("TRF_ST4")).equals("대출")) 		total_amt20 = total_amt20 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					if(String.valueOf(ht.get("TRF_ST4")).equals("포인트")) 	total_amt21 = total_amt21 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					if(String.valueOf(ht.get("TRF_ST4")).equals("구매보조금")) total_amt22 = total_amt22 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					if(String.valueOf(ht.get("TRF_ST4")).equals("카드할부")) 	total_amt24 = total_amt24 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
					
					if(String.valueOf(ht.get("TRF_ST5")).equals("현금")) 		total_amt9  = total_amt9  + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT5")));
					if(String.valueOf(ht.get("TRF_ST5")).equals("선불카드")) 	total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT5")));
					if(String.valueOf(ht.get("TRF_ST5")).equals("후불카드")) 	total_amt11 = total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT5")));
					
					total_amt17 	= total_amt17 + AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT_S")));
					total_amt18 	= total_amt18 + AddUtil.parseLong(String.valueOf(ht.get("PP_IFEE_AMT")));
					total_amt19		= total_amt19 + AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT_S"))) + AddUtil.parseLong(String.valueOf(ht.get("PP_IFEE_AMT")));
					
		 		}%>
	      <%}%>
		        <tr>
        		    <td colspan="8" class=title>합계</td>
        		    <td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt1)%></td>		
        		    <td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt2)%></td>		
        		    <td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt3)%></td>		
        		    <td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt17)%></td>		
        		    <td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt18)%></td>		
        		    <td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt19)%></td>		
        		    <td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt13)%></td>		
        			<td class='title'>&nbsp;</td>									
        			<td class='title'>&nbsp;</td>									
        			<td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt23)%></td>		
        			<td class='title'>&nbsp;</td>									
        			<td class='title'>&nbsp;</td>									
        			<td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt4)%></td>		
        			<td class='title'>&nbsp;</td>
        			<td class='title'>&nbsp;</td>									
        			<td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt5)%></td>		
        			<td class='title'>&nbsp;</td>
        			<td class='title'>&nbsp;</td>									
        			<td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt6)%></td>		
        			<td class='title'>&nbsp;</td>
        			<td class='title'>&nbsp;</td>
        			<td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt7)%></td>		
        			<td class='title' style='text-align:right'><%=Util.parseDecimalLong(total_amt8)%></td>	
        			<td class='title'>&nbsp;</td>
		        </tr>
		    </table>
	    </td>
    </tr>  		    	
	<tr>
		<td align="right">
		  <a href="javascript:print()"><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a><font color=#CCCCCC>&nbsp;(※인쇄TIP : A3, 가로방향)</font>&nbsp;&nbsp;&nbsp;
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>		
	<%if(!doc_no.equals("")){%>	
    <tr>
        <td><< 카드지출분집계표 >></td>
    </tr>  
	<tr>
	    <td>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>		  
        			<td width="1340" class=line>
        			    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        			        <tr>
        			            <td class=line2 style='height:1' colspan=11></td>
        			        </tr>
                            <tr valign="middle" align="center">
                                <td width='30' rowspan="3" class=title>연번</td>
                                <td width='160' rowspan="3" class=title>카드사명</td>
                                <td width='150' rowspan="3" class=title>카드번호</td>
                                <td width='70' rowspan="3" class=title>지출구분</td>
                                <td colspan="5" class=title>거래내역</td>
                                <td width='350' rowspan="3" class=title>거치기간</td>
                            </tr>
                            <tr valign="middle" align="center">
				                        <td colspan="2" class=title>당일거래금액</td>
                                <td colspan="3" class=title>당월누적거래금액</td>
                            </tr>
                            <tr valign="middle" align="center">
				                        <td width='120' class=title>금액</td>
                                <td width='100' class=title>결제예정일</td>
                                <td width='120' class=title>기결제금액</td>
                                <td width='120' class=title>미결제금액</td>
                                <td width='120' class=title>합계</td>
                            </tr>                                                        
        		    <%	Vector vt2 = d_db.getCarPurPayCardStatList(doc.getDoc_id());
        			int vt_size2 = vt2.size();	
        			for(int i = 0 ; i < vt_size2 ; i++){
        				Hashtable ht = (Hashtable)vt2.elementAt(i);
        				String cardno 		= String.valueOf(ht.get("CARDNO"));
        				String trf_st 		= String.valueOf(ht.get("TRF_ST"));
        				String use_s_m 		= String.valueOf(ht.get("USE_S_M"));
        				String use_s_day 	= String.valueOf(ht.get("USE_S_DAY"));
        				String use_e_m 		= String.valueOf(ht.get("USE_E_M"));
        				String use_e_day 	= String.valueOf(ht.get("USE_E_DAY"));
        				int    give_day 	= AddUtil.parseInt(String.valueOf(ht.get("GIVE_DAY")));
        				//당일거래금액
						long d_pay_amt 		= AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));
						//당월누적거래금액
						long m_pay_amt 		= d_db.getCarPurPayCardAmt(cardno, trf_st);
						//당월누적거래금액
						Hashtable mon_amt_ht 	= d_db.getCarPurPayMonCardAmt(cardno, trf_st, String.valueOf(ht.get("PUR_EST_DT")));
						
						
						
						if(trf_st.equals("카드할부")){
							String card_pay_est_dt = String.valueOf(ht.get("PUR_EST_DT"));
							card_pay_est_dt = af_db.getValidDt(c_db.addMonth(card_pay_est_dt, 1));
							ht.put("PAY_DT",card_pay_est_dt);
						}else{
							
							//카드캐쉬백 약정 신용공여일수
							if(give_day > 0){
								String card_pay_est_dt = String.valueOf(ht.get("PUR_EST_DT"));
								if(String.valueOf(ht.get("CARD_KIND")).equals("삼성카드")){
									card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, give_day));
								}else{
									for(int j = 0 ; j < give_day ; j++){
										card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, 1));
									}
								}
								ht.put("PAY_DT",card_pay_est_dt);
							}else{
							
								//승인후 3영업일(초일불산입)
								if(String.valueOf(ht.get("CARD_KIND")).equals("우리BC카드")||String.valueOf(ht.get("CARD_KIND")).equals("부산비씨카드")){
									String card_pay_est_dt = String.valueOf(ht.get("PUR_EST_DT"));
										
									if(card_pay_est_dt.length()>=8){
										//1영업일+
										card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, 1));
										//2영업일+
										card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, 1));
										//3영업일+
										card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, 1));
										
										ht.put("PAY_DT",card_pay_est_dt);							
									}
								}						
								//승인후 2영업일(초일불산입)
								if(String.valueOf(ht.get("CARD_KIND")).equals("롯데카드")||String.valueOf(ht.get("CARD_KIND")).equals("광주카드")||String.valueOf(ht.get("CARD_KIND")).equals("국민카드")){
									String card_pay_est_dt = String.valueOf(ht.get("PUR_EST_DT"));
										
									if(card_pay_est_dt.length()>=8){
										//1영업일+
										card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, 1));
										//2영업일+
										card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, 1));
										
										ht.put("PAY_DT",card_pay_est_dt);							
									}
								}						
								//승인후 4영업일(초일불산입)-> 4영업일
								if(String.valueOf(ht.get("CARD_KIND")).equals("삼성카드")){
									String card_pay_est_dt = String.valueOf(ht.get("PUR_EST_DT"));
										
									if(card_pay_est_dt.length()>=8){
										//1영업일+
										//card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, 1));
										//2영업일+
										//card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, 1));
										//3영업일+
										//card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, 1));
										//4영업일+
																		
										card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, 4));
																		
										ht.put("PAY_DT",card_pay_est_dt);							
									}
								}	
								//승인후 1영업일(초일불산입)
								if(String.valueOf(ht.get("CARD_KIND")).equals("신한카드")){
									String card_pay_est_dt = String.valueOf(ht.get("PUR_EST_DT"));
										
									if(card_pay_est_dt.length()>=8){
										//1영업일+
										card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, 1));
										
										ht.put("PAY_DT",card_pay_est_dt);							
									}
								}						
							}
							//20210128 예정 삼성카드 4327-6800-0000-0122 일주일 예외 추가 적용
							if(String.valueOf(ht.get("CARD_KIND")).equals("삼성카드") && String.valueOf(ht.get("PUR_EST_DT")).equals("20210128") && cardno.equals("4327-6800-0000-0122")){
								String card_pay_est_dt = String.valueOf(ht.get("PAY_DT"));
								card_pay_est_dt = af_db.getValidDt(c_db.addDay(card_pay_est_dt, 7));
								ht.put("PAY_DT",card_pay_est_dt);		
							}
							
							//20210701 우리비씨-차량구매카드 후불카드  전전월13일~전월12일 매월5일
							//if(cardno.equals("9435-2017-1000-5190")){
								
							//20210701 모든카드 후불카드 원래 지급예정일	
							if(AddUtil.parseInt(String.valueOf(ht.get("PUR_EST_DT"))) >= 20210701){	
								String card_pay_est_dt = String.valueOf(ht.get("PUR_EST_DT"));
								//out.println(cardno);
								//out.println(card_pay_est_dt);
								card_pay_est_dt = af_db.getCardValidDt(cardno, card_pay_est_dt);
								//out.println(card_pay_est_dt);
								ht.put("PAY_DT",card_pay_est_dt);
							}
							
						}


        		    %>	
                            <tr valign="middle" align="center">
                                <td><%=i+1%></td>
                                <td><%=ht.get("COM_NAME")%></td>
                                <td><%=cardno%></td>
                                <td><%=trf_st%></td>
				<td align="right"><%=AddUtil.parseDecimalLong(d_pay_amt)%></td>
				<td>
				<%if(String.valueOf(ht.get("PAY_DT")).length()>=8){%>				
				<%=AddUtil.ChangeDate2(af_db.getValidDt(String.valueOf(ht.get("PAY_DT"))))%>
				<%}else{%>
				<%=ht.get("PAY_DT")%>
				<%}%>
				</td>
				<td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(mon_amt_ht.get("AMT1"))))%></td>
				<td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(mon_amt_ht.get("AMT2"))))%></td>
                                <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(mon_amt_ht.get("T_AMT"))))%></td>
                                <td>
                                <%if(trf_st.equals("카드할부")){%>
                                카드할부
                                <%}else{ %>
                                <%	if(AddUtil.parseInt(String.valueOf(ht.get("PUR_EST_DT"))) >= 20210701){%>
                                매월<%=ht.get("PAY_DAY") %>일
                                <%	}else{%>
                                	<%if(give_day > 0){%>
                                		  승인후 <%=give_day%><%if(String.valueOf(ht.get("CARD_KIND")).equals("삼성카드")){%>일째 달력일<%}else{%>영업일<%}%>(초일불산입)
                                		  <%if(String.valueOf(ht.get("CARD_KIND")).equals("롯데카드")){%>, 금요일 사용 화요일 상환<%}%>
                                		<%}else{%>
                                    	<%if(String.valueOf(ht.get("CARD_KIND")).equals("삼성카드")){%>승인후 4일 달력일(초일불산입)<%}%>
                                    	<%if(String.valueOf(ht.get("CARD_KIND")).equals("우리BC카드")||String.valueOf(ht.get("CARD_KIND")).equals("부산비씨카드")){%>승인후 3영업일(초일불산입)<%}%>
                                    	<%if(String.valueOf(ht.get("CARD_KIND")).equals("신한카드")){%>승인후 1영업일(초일불산입)<%}%>
                                    	<%if(String.valueOf(ht.get("CARD_KIND")).equals("현대카드")){%>1주간 승인건 합산후 익주 수요일<%}%>
                                    	<%if(String.valueOf(ht.get("CARD_KIND")).equals("롯데카드")){%>승인후 2영업일(초일불산입), 금요일 사용 화요일 상환<%}%>
                                    	<%if(String.valueOf(ht.get("CARD_KIND")).equals("광주카드")||String.valueOf(ht.get("CARD_KIND")).equals("국민카드")){%>승인후 2영업일(초일불산입)<%}%>
                                    <%}%>
                                    
                                    <%if(String.valueOf(ht.get("CARD_KIND")).equals("삼성카드") && String.valueOf(ht.get("PUR_EST_DT")).equals("20210128") && cardno.equals("4327-6800-0000-0122")){ %>
                                    +7일
                                    <%} %>
                                 <%  } %>
                                 <%} %>   
                                    
                                </td>
                            </tr>
        		    <%				total_amt14 = total_amt14 +d_pay_amt;
        							total_amt15 = total_amt15 +m_pay_amt;
        		      	}
        		    %>
        		    <!-- 카드할부 -->
        		    <%	Vector vt3 = d_db.getCarPurPayCardDebtStatList(doc.getDoc_id());
        			int vt_size3 = vt3.size();	
        			for(int i = 0 ; i < vt_size3 ; i++){
        				Hashtable ht = (Hashtable)vt3.elementAt(i);
        				String cardno 		= String.valueOf(ht.get("CARDNO"));
        				String trf_st 		= String.valueOf(ht.get("TRF_ST"));
        				//당일거래금액
						long d_pay_amt 		= AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));
        		    %>	
                            <tr valign="middle" align="center">
                                <td><%=vt_size2+i+1%></td>
                                <td><%=ht.get("COM_NAME")%></td>
                                <td><%//=cardno%></td>
                                <td><%=trf_st%></td>
				<td align="right"><%=AddUtil.parseDecimalLong(d_pay_amt)%></td>
				<td></td>
				<td align="right"></td>
				<td align="right"></td>
                                <td align="right"></td>
                                <td>
                                </td>
                            </tr>
        		    <%				total_amt14 = total_amt14 +d_pay_amt;
        							
        		      	}
        		    %>        		    
        		    
                            <tr valign="middle" align="center">
                                <td colspan="4" class=title>합계</td>
                                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt14)%></td>
                                <td class=title></td>
                                <td class=title></td>
                                <td class=title></td>
                                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt15)%></td>
                                <td class=title></td>
                            </tr>
                        </table>
        	    </td>	
        	    <td width="1570">&nbsp;</td>
                </tr>
            </table>
	    </td>	
	</tr>
	<%}%>
	<tr>
		<td>&nbsp;</td>	
	</tr>	
	<%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){
	
		if(!doc.getDoc_no().equals("")){
			//pur_est_dt = doc.getDoc_dt();
		}%>	
	<tr>
	    <td>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>		  
        			<td width="700" class=line>
        			    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        			        <tr>
		                        <td class=line2 style='height:1'></td>
		                    </tr>
                            <tr valign="middle" align="center">
                                <td rowspan='2' colspan='2' class=title>구분</td>
                                <td rowspan='2' width='100' class=title>금액</td>
                                <td rowspan='2' width='100' class=title>지출예정일자</td>
                                <td colspan='2' class=title>지출금액 누계</td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td width='100' class=title>당월</td>
                                <td width='100' class=title>당기</td>
                            </tr>    
                            <%
                          		//당월, 당기 누계
        						Hashtable trf_st1_amt_ht 	= d_db.getCarPurPayAmtStat("1", pur_est_dt);
                            	Hashtable trf_st2_amt_ht 	= d_db.getCarPurPayAmtStat("2", pur_est_dt);
                            	Hashtable trf_st3_amt_ht 	= d_db.getCarPurPayAmtStat("3", pur_est_dt);
                            	Hashtable trf_st4_amt_ht 	= d_db.getCarPurPayAmtStat("4", pur_est_dt);
                            	Hashtable trf_st5_amt_ht 	= d_db.getCarPurPayAmtStat("5", pur_est_dt);
                            	Hashtable trf_st6_amt_ht 	= d_db.getCarPurPayAmtStat("6", pur_est_dt);
                            	Hashtable trf_st7_amt_ht 	= d_db.getCarPurPayAmtStat("7", pur_est_dt);
                            %>                        
                            <tr valign="middle" align="center">
                                <td colspan='2' align='center'>현금</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt9)%></td>
                                <td align='center'></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st1_amt_ht.get("MON_AMT"))))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st1_amt_ht.get("YEAR_AMT"))))%></td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td width='100' rowspan='4' align='center'>신용카드</td>
                                <td width='200' align='center'>선불카드</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt10)%></td>
                                <td align='center'></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st2_amt_ht.get("MON_AMT"))))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st2_amt_ht.get("YEAR_AMT"))))%></td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td align='center'>후불카드</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt11)%></td>
                                <td align='center'></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st3_amt_ht.get("MON_AMT"))))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st3_amt_ht.get("YEAR_AMT"))))%></td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td align='center'>카드할부</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt24)%></td>
                                <td align='center'></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st7_amt_ht.get("MON_AMT"))))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st7_amt_ht.get("YEAR_AMT"))))%></td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td align='center'>소계</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt10+total_amt11)%></td>
                                <td align='center'></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st2_amt_ht.get("MON_AMT")))+AddUtil.parseLong(String.valueOf(trf_st3_amt_ht.get("MON_AMT")))+AddUtil.parseLong(String.valueOf(trf_st7_amt_ht.get("MON_AMT"))))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st2_amt_ht.get("YEAR_AMT")))+AddUtil.parseLong(String.valueOf(trf_st3_amt_ht.get("YEAR_AMT")))+AddUtil.parseLong(String.valueOf(trf_st7_amt_ht.get("YEAR_AMT"))))%></td>
                            </tr>                            
                            <tr valign="middle" align="center">
                                <td rowspan='4' align='center'>대체거래</td>
                                <td align='center'>대출</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt20)%></td>
                                <td align='center'></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st4_amt_ht.get("MON_AMT"))))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st4_amt_ht.get("YEAR_AMT"))))%></td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td align='center'>현대자동차 블루멤버스 포인트</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt21)%></td>
                                <td align='center'></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st5_amt_ht.get("MON_AMT"))))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st5_amt_ht.get("YEAR_AMT"))))%></td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td align='center'>정부보조금(전기/수소차)</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt22)%></td>
                                <td align='center'></td>                                
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st6_amt_ht.get("MON_AMT"))))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st6_amt_ht.get("YEAR_AMT"))))%></td>
                            </tr>
                            <tr valign="middle" align="center">
                                <td align='center'>소계</td>
                                <td align='right'><%=AddUtil.parseDecimalLong(total_amt20+total_amt21+total_amt22)%></td>
                                <td align='center'></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st4_amt_ht.get("MON_AMT")))+AddUtil.parseLong(String.valueOf(trf_st5_amt_ht.get("MON_AMT")))+AddUtil.parseLong(String.valueOf(trf_st6_amt_ht.get("MON_AMT"))))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st4_amt_ht.get("YEAR_AMT")))+AddUtil.parseLong(String.valueOf(trf_st5_amt_ht.get("YEAR_AMT")))+AddUtil.parseLong(String.valueOf(trf_st6_amt_ht.get("YEAR_AMT"))))%></td>
                            </tr>                                    
                            <tr valign="middle" align="center">
                                <td colspan='2' class=title>합계</td>
                                <td class=title style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt9+total_amt10+total_amt11+total_amt20+total_amt21+total_amt22+total_amt24)%></td>
                                <td align='center'><input type='text' size='11' name='pur_est_dt' maxlength='10' class='text' value='<%=AddUtil.ChangeDate2(pur_est_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st1_amt_ht.get("MON_AMT")))+AddUtil.parseLong(String.valueOf(trf_st2_amt_ht.get("MON_AMT")))+AddUtil.parseLong(String.valueOf(trf_st3_amt_ht.get("MON_AMT")))+AddUtil.parseLong(String.valueOf(trf_st4_amt_ht.get("MON_AMT")))+AddUtil.parseLong(String.valueOf(trf_st5_amt_ht.get("MON_AMT")))+AddUtil.parseLong(String.valueOf(trf_st6_amt_ht.get("MON_AMT")))+AddUtil.parseLong(String.valueOf(trf_st7_amt_ht.get("MON_AMT"))))%></td>
                                <td align='right'><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(trf_st1_amt_ht.get("YEAR_AMT")))+AddUtil.parseLong(String.valueOf(trf_st2_amt_ht.get("YEAR_AMT")))+AddUtil.parseLong(String.valueOf(trf_st3_amt_ht.get("YEAR_AMT")))+AddUtil.parseLong(String.valueOf(trf_st4_amt_ht.get("YEAR_AMT")))+AddUtil.parseLong(String.valueOf(trf_st5_amt_ht.get("YEAR_AMT")))+AddUtil.parseLong(String.valueOf(trf_st6_amt_ht.get("YEAR_AMT")))+AddUtil.parseLong(String.valueOf(trf_st7_amt_ht.get("YEAR_AMT"))))%></td>
                            </tr>
                        </table>			
        			</td>	
        			<td width="10">&nbsp;</td>							  
                    <td width="630" class=line>                    
        			    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                            <tr valign="middle" align="center">
                                <td width='30' rowspan="2" class=title>결<br>재</td>
                                <td width='150' class=title>지점명</td>
                                <td width='150' class=title>담당자</td>
                                <td width='150' class=title>팀장</td>
                                <td width='150' class=title>대표이사</td>	  
                            </tr>
                            <tr>
                                <td align='center'>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                                   <%=user_bean.getBr_nm()%><br>
                                                   &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                </td>
                                <td align='center'>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                                   <%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br>
                                                   &nbsp;<br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("")){%><a href="javascript:doc_sanction('1')"><img src=/acar/images/center/button_in_gj.gif border=0 align=absmiddle></a><%}%><br>
                                                   &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                </td>
                                <td align='center'>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                                   <%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br>
                                                   &nbsp;<br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%><%if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("카드관리자",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("본사영업팀장",user_id) || nm_db.getWorkAuthUser("본사총무팀장",user_id) || nm_db.getWorkAuthUser("차량대금팀장결재대행",user_id)){%><a href="javascript:doc_sanction('2')"><img src=/acar/images/center/button_in_gj.gif border=0 align=absmiddle></a><%}%><%}%><br>
                                                   &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                </td>				
                                <td align='center'>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                                   <%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br>
                                                   &nbsp;<br><%=doc.getUser_dt3()%><%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("")){%><!--<a href="javascript:doc_sanction('1')">결재</a><br>&nbsp;--><%}%><br>
                                                   &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                </td>
                            </tr>
                        </table>
        			</td>
        			<td width="1570">&nbsp;</td>
                </tr>	
            </table>		  
	    </td>	
	</tr>
	<%}%>			  
</table>
  <input type='hidden' name='size' value='<%=vt_size%>'>  
  <input type='hidden' name='amt1' value='<%=total_amt9%>'>
  <input type='hidden' name='amt2' value='<%=total_amt10%>'>
  <input type='hidden' name='amt3' value='<%=total_amt11%>'>
  <input type='hidden' name='amt4' value='<%=total_amt12%>'>
  <input type='hidden' name='s1'   value='<%=s1%>'>
  <input type='hidden' name='b1'   value='<%=b1%>'>
  <input type='hidden' name='d1'   value='<%=d1%>'>  
  <input type='hidden' name='s2'   value='<%=s2%>'>
  <input type='hidden' name='j1'   value='<%=j1%>'>
  <input type='hidden' name='g1'   value='<%=g1%>'>  
  <input type='hidden' name='i1'   value='<%=i1%>'>  
  <input type='hidden' name='k3'   value='<%=k3%>'>  
  <input type='hidden' name='s3'   value='<%=s3%>'>  
  <input type='hidden' name='s4'   value='<%=s4%>'>  
  <input type='hidden' name='u1'   value='<%=u1%>'>  
  <input type='hidden' name='s5'   value='<%=s5%>'>  
  <input type='hidden' name='s6'   value='<%=s6%>'>  
</form>  
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
