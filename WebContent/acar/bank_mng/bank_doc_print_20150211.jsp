<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

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
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	//대출신청리스트
	Vector FineList = FineDocDb.getBankDocLists(doc_id);
	
	if(FineDocBn.getH_mng_id().equals(""))		FineDocBn.setH_mng_id("000004");
	if(FineDocBn.getB_mng_id().equals(""))		FineDocBn.setB_mng_id("000048");
	
	//담당자정보
	UserMngDatabase u_db = UserMngDatabase.getInstance();		
	UsersBean h_user = u_db.getUsersBean(FineDocBn.getH_mng_id());
	UsersBean b_user = u_db.getUsersBean(FineDocBn.getB_mng_id());
	
	Hashtable br1 = c_db.getBranch(b_user.getBr_id());
		
	//인쇄여부 수정
	if(FineDocBn.getPrint_dt().equals("")){
		FineDocDb.changePrint_dt(doc_id, user_id);
	}

	EstiDatabase e_db = EstiDatabase.getInstance();
	//변수
	String var1 = e_db.getEstiSikVarCase("1", "", "bank1");//담당부서장
	String var2 = e_db.getEstiSikVarCase("1", "", "bank2");	//담당자	
	String var3 = e_db.getEstiSikVarCase("1", "", "bank_app1");//첨부서류1
	String var4 = e_db.getEstiSikVarCase("1", "", "bank_app2");//첨부서류2
	String var5 = e_db.getEstiSikVarCase("1", "", "bank_app3");//첨부서류3
	String var6 = e_db.getEstiSikVarCase("1", "", "bank_app4");//첨부서류4
	String var7 ="";
	 if  (Integer.parseInt(FineDocBn.getDoc_dt()) > 20141204) {	
		 var7 = e_db.getEstiSikVarCase("1", "", "bank_app6");//첨부서류5
	 } else {
		 var7 = e_db.getEstiSikVarCase("1", "", "bank_app5");//첨부서류5
	} 
			
	int app_doc_h = 0;
	String app_doc_v = "";
	if(FineDocBn.getApp_doc1().equals("Y")){	
		app_doc_h += 20;
		app_doc_v += "1";
	}
	if(FineDocBn.getApp_doc2().equals("Y")){
		app_doc_h += 20;
		app_doc_v += "2";
	}
	if(FineDocBn.getApp_doc3().equals("Y")){
		app_doc_h += 20;
		app_doc_v += "3";
	}
	if(FineDocBn.getApp_doc4().equals("Y")){
		app_doc_h += 20;
		app_doc_v += "4";
	}
	if(FineDocBn.getApp_doc5().equals("Y")){		
		app_doc_h += 20;
		app_doc_v += "5";
	}
	
	int app_doc_size = app_doc_h/20;	
				
	//내용 라인수
	int tot_size =  FineList.size();
	
	//외환캐피탈|| 효성캐피탈 || 하나은행 || 하나캐피탈 ||외환은행 || 우리파이낸셜|| hk저축은행||현대캐피탈 || 수협은행 || 전북은행    라인수 강제조정
	if ( FineDocBn.getGov_id().equals("0057") || FineDocBn.getGov_id().equals("0018") || FineDocBn.getGov_id().equals("0026") || FineDocBn.getGov_id().equals("0039") ||  FineDocBn.getGov_id().equals("0040") || FineDocBn.getGov_id().equals("0038") || FineDocBn.getGov_id().equals("0004") || FineDocBn.getGov_id().equals("0039") || FineDocBn.getGov_id().equals("0001") || FineDocBn.getGov_id().equals("0009") || FineDocBn.getGov_id().equals("0003") || FineDocBn.getGov_id().equals("0043") || FineDocBn.getGov_id().equals("0041") || FineDocBn.getGov_id().equals("0044") || FineDocBn.getGov_id().equals("0002") || FineDocBn.getGov_id().equals("0051") || FineDocBn.getGov_id().equals("0055")  || FineDocBn.getGov_id().equals("0059") || FineDocBn.getGov_id().equals("0058")  || FineDocBn.getGov_id().equals("0060")  || FineDocBn.getGov_id().equals("0037") || FineDocBn.getGov_id().equals("0011")  || FineDocBn.getGov_id().equals("0063") || FineDocBn.getGov_id().equals("0028")  || FineDocBn.getGov_id().equals("0064")  || FineDocBn.getGov_id().equals("0033")   || FineDocBn.getGov_id().equals("0065")   || FineDocBn.getGov_id().equals("0029")     || FineDocBn.getGov_id().equals("0025")   || FineDocBn.getGov_id().equals("0068")    || FineDocBn.getGov_id().equals("0074")  || FineDocBn.getGov_id().equals("0076")  ) {
	    tot_size=1;
	}
	int line_h = 32;
	//페이지 길이
	int page_h = 850;
	//각 테이블 기본 길이
	int table1_h = 315+120;
	int table2_h = tot_size*line_h;	
	int table3_h = app_doc_h+140;
	
	//출력페이지수 구하기
	int page_cnt = ((table1_h+table2_h+table3_h)/page_h);
	if((table1_h+table2_h+table3_h)%page_h != 0) page_cnt = page_cnt + 1;
	
	//마지막 테이블 길이 구하기
	int height = (page_h*page_cnt)-(table1_h+table2_h);	
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
       long t_amt4[] = new long[1];
         long t_amt5[] = new long[1];
	
	long s_amt1[] = new long[1];
    long s_amt2[] = new long[1];
    long s_amt3[] = new long[1];
    
        long s_amt4[] = new long[1];
         long s_amt5[] = new long[1];
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 12.0; //좌측여백   
		factory.printing.rightMargin 	= 12.0; //우측여백
		factory.printing.topMargin 	= 20.0; //상단여백    
		factory.printing.bottomMargin 	= 30.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}

</script>
</head>
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
</object>

<form action="" name="form1" method="POST" >
  <table width='670' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td colspan="2" height="40" align="center" style="font-size : 18pt;"><b><font face="바탕">Pick 
        amazoncar! We'll pick you up.</font></b></td>
    </tr>
    <tr> 
      <td colspan="2" height="5" align="center"></td>
    </tr>
    <tr bgcolor="#000000"> 
      <td colspan="2" align='center' height="10"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#FFFFFF"> 
            <td height="40"> <table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr> 
                  <td height="20" colspan="2" style="font-size : 9pt;"><font face="바탕"><%=br1.get("BR_POST")%>
                    <%=br1.get("BR_ADDR")%></font></td>
                  <td height="20" style="font-size : 9pt;" ><font face="바탕">Tel:<%=b_user.getHot_tel()%></font></td>
                  <td height="20" style="font-size : 9pt;" ><font face="바탕">Fax:<%=br1.get("FAX")%></font></td>
                </tr>
                <tr> 
                  <td height="20" style="font-size : 9pt;"><font face="바탕"><%=h_user.getDept_nm()%>장 
                    <%=h_user.getUser_nm()%></font></td>
                  <td height="20" style="font-size : 9pt;"><font face="바탕">담당자 
                    <%=b_user.getUser_nm()%>(<%=b_user.getUser_email()%>)</font></td>
                  <td height="20" colspan="2" style="font-size : 9pt;"><font face="바탕">http://www.amazoncar.co.kr</font></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="20" colspan="2" align='center'></td>
    </tr>
    <tr> 
      <td height="125" colspan="2" align='center'> <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="10%" height="25" style="font-size : 10pt;"><font face="바탕">문서번호</font></td>
            <td width="3%" height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" width="87%" style="font-size : 10pt;"><font face="바탕"><%=FineDocBn.getDoc_id()%> 
              </font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">시행일자</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 신</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=c_db.getNameById(FineDocBn.getGov_id(), "BANK")%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">참&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 조</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=FineDocBn.getMng_dept()%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 목</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">자동차 구입에 필요한 자금의 대출 요청</font></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="20" colspan="2" align='center'></td>
    </tr>
    <tr bgcolor="#999999"> 
      <td colspan=2 align='center' height="3" bgcolor="#333333"></td>
    </tr>
    <tr> 
      <td height="20" colspan=2 align='center'>&nbsp;</td>
    </tr>
    <tr> 
      <td align='center' height="30" width="13%" style="font-size : 10pt;"><font face="바탕">&nbsp;</font></td>
      <td width="87%" height="30" style="font-size : 10pt;"><font face="바탕">1. 귀 사의 
        무궁한 발전을 기원합니다.</font></td>
    </tr>
    <tr> 
      <td align='center' height="30" style="font-size : 10pt;"><font face="바탕">&nbsp;</font></td>
      <td height="30" style="font-size : 10pt;"><font face="바탕">2. 아래와 같이 자동차 구입에 필요한 자금의 대출을 요청하오니, 검토 후 실행하여 
        </font></td>
    </tr>
    <tr> 
      <td height="30" colspan="2" style="font-size : 10pt;"><font face="바탕"> 주십시오.
        </font></td>
    </tr>
   
    <tr> 
      <td colspan=2 align='center' height="50" style="font-size : 9pt;"><font size="2" face="바탕">== 아&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;래 
        ==</font></td>
    </tr>
    <tr bgcolor="#000000"> 
      <td colspan="2" align='center' height="10"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#A6FFFF" align="center"> 
            <td style="font-size : 8pt;" colspan="2"width="20%" height="30"><font face="바탕">상환조건</font></td>
            <td style="font-size : 8pt;" rowspan="2" width="10%"><font face="바탕">구입대수</font></td>
            <td style="font-size : 8pt;" rowspan="2" width="15%"><font face="바탕">구입가격</font></td>
            <td style="font-size : 8pt;" colspan="2" width="30%"><font face="바탕">대출</font></td>
            <td style="font-size : 8pt;" rowspan="2" width="15%"><font face="바탕">설정금액</font></td>
            <td style="font-size : 8pt;" rowspan="2" width="10%"><font face="바탕">대출금리</font></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td style="font-size : 8pt;" width="10%" height="25" align="center" bgcolor="#A6FFFF"><font face="바탕">기간</font></td>
            <td style="font-size : 8pt;" width="10%" align="center" bgcolor="#A6FFFF"><font face="바탕">방법</font></td>
            <td style="font-size : 8pt;" width="15%" align="center" bgcolor="#A6FFFF"><font face="바탕">금액</font></td>
            <td style="font-size : 8pt;" width="15%" align="center" bgcolor="#A6FFFF"><font face="바탕">실행일자</font></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="2" colspan="2"></td>
    </tr>
  </table>
  <table width='670' height="<%//=table2_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr bgcolor="#000000">
      <td width="100%" height="10" align='center'><table width="100%" border="0" cellspacing="1" cellpadding="0">
<% if(FineList.size()>0){
          		
		for(int i=0; i<FineList.size(); i++){ 
			FineDocListBn = (FineDocListBean)FineList.elementAt(i); 

			for(int j=0; j<1; j++){
		
				t_amt1[j] += AddUtil.parseLong(String.valueOf(FineDocListBn.getAmt1()));
				t_amt2[j] += AddUtil.parseLong(String.valueOf(FineDocListBn.getAmt2()));
				t_amt3[j] += AddUtil.parseLong(String.valueOf(FineDocListBn.getAmt3()));
			
				//저당권금액 저장 - 20120503	
				t_amt4[j] += AddUtil.parseLong(String.valueOf(FineDocListBn.getAmt6()));
				
																		
				//sbi4  36미만은 36 그 이상은 원래, 산은0010 36미만은 원래개월 , 36이상은 36으로 , 외환 0040 36개월 IBK 0057은 36개월, 롯데0038은 36개월, 하나0041은 36개월, 신한은행은 36개월, 신한캐피탈(0009)은 36개월, 효성캐피탈(0039)은 36,  hk저축은행(0059)은 36,  무림(0058)은 36, 현대캐피탈(0011)은 36, 수협(0028)은 36 , 광주은행(0029)은 36
				if( ( AddUtil.parseInt(String.valueOf(FineDocListBn.getPaid_no())) <=36 &&  FineDocBn.getGov_id().equals("0073") ) ||   ( AddUtil.parseInt(String.valueOf(FineDocListBn.getPaid_no())) >= 36 &&  FineDocBn.getGov_id().equals("0010") )  ||  FineDocBn.getGov_id().equals("0056") || FineDocBn.getGov_id().equals("0039") || FineDocBn.getGov_id().equals("0004") || FineDocBn.getGov_id().equals("0043") || FineDocBn.getGov_id().equals("0001") || FineDocBn.getGov_id().equals("0041") || FineDocBn.getGov_id().equals("0044") || FineDocBn.getGov_id().equals("0057")  || FineDocBn.getGov_id().equals("0005")  || FineDocBn.getGov_id().equals("0009")  ||   FineDocBn.getGov_id().equals("0003") || FineDocBn.getGov_id().equals("0038") || FineDocBn.getGov_id().equals("0055") || FineDocBn.getGov_id().equals("0018") ||  FineDocBn.getGov_id().equals("0026")  ||  FineDocBn.getGov_id().equals("0051")   ||  FineDocBn.getGov_id().equals("0039")  ||  FineDocBn.getGov_id().equals("0040")  ||  FineDocBn.getGov_id().equals("0059") ||  FineDocBn.getGov_id().equals("0058")   ||  FineDocBn.getGov_id().equals("0060")   ||  FineDocBn.getGov_id().equals("0037")   ||  FineDocBn.getGov_id().equals("0011")   ||  FineDocBn.getGov_id().equals("0002")  ||  FineDocBn.getGov_id().equals("0063")  ||  FineDocBn.getGov_id().equals("0028")   ||  FineDocBn.getGov_id().equals("0064")  ||  FineDocBn.getGov_id().equals("0065")   ||  FineDocBn.getGov_id().equals("0029")  ||  FineDocBn.getGov_id().equals("0033")  ||  FineDocBn.getGov_id().equals("0025")   ||  FineDocBn.getGov_id().equals("0068")    ||  FineDocBn.getGov_id().equals("0069")   ||  FineDocBn.getGov_id().equals("0072") ||  FineDocBn.getGov_id().equals("0074") ||  FineDocBn.getGov_id().equals("0075")   ||  FineDocBn.getGov_id().equals("0076")  ){	
					s_amt1[j] += AddUtil.parseLong(String.valueOf(FineDocListBn.getAmt1()));				
					s_amt2[j] += AddUtil.parseLong(String.valueOf(FineDocListBn.getAmt2()));
					s_amt3[j] += AddUtil.parseLong(String.valueOf(FineDocListBn.getAmt3()));	
					s_amt4[j] += AddUtil.parseLong(String.valueOf(FineDocListBn.getAmt6()));   // 저당권 저장사용
				
				}
					
			}
						
%>

<% if (   (FineDocBn.getGov_id().equals("0010") && AddUtil.parseInt(String.valueOf(FineDocListBn.getPaid_no())) < 36)   ) { %>	
         		
	<tr bgcolor="#FFFFFF" align="center">
            <td width="10%" height="<%=line_h%>" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕"><%if(AddUtil.parseInt(String.valueOf(FineDocListBn.getPaid_no())) >= 36 ){%>36개월<%}else{%><%=FineDocListBn.getPaid_no()%>개월<%}%></font></td>
            <td width="10%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getCar_st()%></font></td>
            <td width="10%" style="font-size : 8pt;" ><font face="바탕"><%=FineDocListBn.getAmt1()%></font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(String.valueOf(FineDocListBn.getAmt2()))%>&nbsp;</font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(String.valueOf(FineDocListBn.getAmt3()))%>&nbsp;</font></td>
            <td width="15%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getVio_dt()%></font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"> <%=Util.parseDecimal(String.valueOf(FineDocListBn.getAmt6() ))%>&nbsp;                  
            </font></td>
            <td width="10%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getScan_file()%></font></td>
        </tr>
<% 	} %>   
     
  <% if ( (  (FineDocBn.getGov_id().equals("0073") && AddUtil.parseInt(String.valueOf(FineDocListBn.getPaid_no())) > 36)  ) ) { %>	
		 <tr bgcolor="#FFFFFF" align="center">
            <td width="10%" height="<%=line_h%>" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getPaid_no()%>개월</font></td>
              <td width="10%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getCar_st()%></font></td>
            <td width="10%" style="font-size : 8pt;" ><font face="바탕"><%=FineDocListBn.getAmt1()%></font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(String.valueOf(FineDocListBn.getAmt2()))%>&nbsp;</font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(String.valueOf(FineDocListBn.getAmt3()))%>&nbsp;</font></td>
            <td width="15%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getVio_dt()%></font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"> <%=Util.parseDecimal(String.valueOf(FineDocListBn.getAmt6() ))%>&nbsp;                  
            </font></td>
            <td width="10%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getScan_file()%></font></td>
          </tr>
 <% 	} %>    
    
<%  } %> 
		
<% if ( ( AddUtil.parseInt(String.valueOf(FineDocListBn.getPaid_no())) >= 36 && FineDocBn.getGov_id().equals("0010")  ) ||   FineDocBn.getGov_id().equals("0005") ||   FineDocBn.getGov_id().equals("0056") || FineDocBn.getGov_id().equals("0057")  || FineDocBn.getGov_id().equals("0040")  || FineDocBn.getGov_id().equals("0038") || FineDocBn.getGov_id().equals("0039") || FineDocBn.getGov_id().equals("0001") ||  FineDocBn.getGov_id().equals("0009")  ||  FineDocBn.getGov_id().equals("0003") ||  FineDocBn.getGov_id().equals("0004") ||  FineDocBn.getGov_id().equals("0043") ||  FineDocBn.getGov_id().equals("0044") || FineDocBn.getGov_id().equals("0041") || FineDocBn.getGov_id().equals("0002") || FineDocBn.getGov_id().equals("0051") || FineDocBn.getGov_id().equals("0055") || FineDocBn.getGov_id().equals("0018") ||  FineDocBn.getGov_id().equals("0026")   ||  FineDocBn.getGov_id().equals("0039")   ||  FineDocBn.getGov_id().equals("0059")    ||  FineDocBn.getGov_id().equals("0058")  ||  FineDocBn.getGov_id().equals("0060")  ||  FineDocBn.getGov_id().equals("0037")   ||  FineDocBn.getGov_id().equals("0011")   ||  FineDocBn.getGov_id().equals("0063")    ||  FineDocBn.getGov_id().equals("0028")  ||  FineDocBn.getGov_id().equals("0064")  ||  FineDocBn.getGov_id().equals("0065")  ||  FineDocBn.getGov_id().equals("0029")   ||  FineDocBn.getGov_id().equals("0033")   ||  FineDocBn.getGov_id().equals("0025") ||  FineDocBn.getGov_id().equals("0068")   ||  FineDocBn.getGov_id().equals("0069")   ||  FineDocBn.getGov_id().equals("0072")  ||   FineDocBn.getGov_id().equals("0074")   ||  FineDocBn.getGov_id().equals("0075")  ||  FineDocBn.getGov_id().equals("0076")  ) { %>	
		 <tr bgcolor="#FFFFFF" align="center">
            <td width="10%" height="<%=line_h%>" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕">36개월</font></td>
            <td width="10%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getCar_st()%></font></td>
            <td width="10%" style="font-size : 8pt;" ><font face="바탕"><%=Util.parseDecimal(s_amt1[0])%></font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(s_amt2[0])%>&nbsp;</font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(s_amt3[0])%>&nbsp;</font></td>
            <td width="15%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getVio_dt()%></font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(s_amt4[0])%>&nbsp;</font></td>
            <td width="10%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getScan_file()%></font></td>
          </tr>
 <% 	} %>     
 
 <% if ( ( AddUtil.parseInt(String.valueOf(FineDocListBn.getPaid_no())) > 36 && FineDocBn.getGov_id().equals("0073")  )  ) { %>	
		 <tr bgcolor="#FFFFFF" align="center">
            <td width="10%" height="<%=line_h%>" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕">36개월</font></td>
            <td width="10%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getCar_st()%></font></td>
            <td width="10%" style="font-size : 8pt;" ><font face="바탕"><%=Util.parseDecimal(s_amt1[0])%></font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(s_amt2[0])%>&nbsp;</font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(s_amt3[0])%>&nbsp;</font></td>
            <td width="15%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getVio_dt()%></font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(s_amt4[0])%>&nbsp;</font></td>
            <td width="10%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getScan_file()%></font></td>
          </tr>
 <% 	} %>    
    
         <tr bgcolor="#FFFFFF" align="center">
            <td colspan=2 height="<%=line_h%>" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕">합계</font></td>
            <td width="10%" style="font-size : 8pt;" ><font face="바탕"><%=Util.parseDecimal(t_amt1[0])%></font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt2[0])%>&nbsp;</font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt3[0])%>&nbsp;</font></td>
            <td width="15%" style="font-size : 8pt;"><font face="바탕"></font></td>
            <td width="15%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt4[0])%>&nbsp;</font></td>
            <td width="10%" style="font-size : 8pt;"><font face="바탕"></font></td>
          
          </tr>
<%} %>
      </table></td>
    </tr>
  </table>
  <table width='670' height="<%=height%>" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td colspan=2 align='center' height="20"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr> 
      <td colspan=2 align='right' height="20" style="font-size : 10pt;"><font face="바탕">- 끝 -</font></td>
    </tr>
    <tr> 
      <td colspan=2 height="20"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr> 
      <td colspan=2 height="20" style="font-size : 10pt;"><font face="바탕"># 첨&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
        부</font></td>
    </tr>
    <%for(int i=0; i<app_doc_size; i++){%>
    <tr> 
      <td width="13%" height="20" style="font-size : 10pt;"><font face="바탕">&nbsp;</font></td>
      <td width="87%" height="20" style="font-size : 10pt;"><font face="바탕"><%=i+1%>) 
        <%if(app_doc_v.substring(i,i+1).equals("1")){%>
        <%=var3%> 
        <%}%>
        <%if(app_doc_v.substring(i,i+1).equals("2")){%>
        <%=var4%> 
        <%}%>
        <%if(app_doc_v.substring(i,i+1).equals("3")){%>
        <%=var5%> 
        <%}%>
        <%if(app_doc_v.substring(i,i+1).equals("4")){%>
        <%=var6%> 
        <%}%>
        <%if(app_doc_v.substring(i,i+1).equals("5")){%>
        <%=var7%> 
        <%}%>
        </font></td>
    </tr>
    <%}%>
    <tr> 
      <td colspan="2"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr align="center"> 
      <td height="40" colspan="2" style="font-size : 19pt;"><font face="바탕"><b>주식회사 
        아마존카 대표이사 조&nbsp;&nbsp;성&nbsp;&nbsp;희</b></font></td>
    </tr>
  </table>
</form>
</body>
</html>
�