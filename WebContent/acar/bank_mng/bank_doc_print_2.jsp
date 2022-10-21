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
	
	//String amt = request.getParameter("amt")==null?"":request.getParameter("amt");
	String cnt = request.getParameter("cnt")==null?"":request.getParameter("cnt");
	
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
	
	long amt = 0;
	double amt1_tot = 0; //등록세
	double amt2_tot = 0; //증지세
	int loan_amt1 = 0;
	int loan_amt2 = 0;
	
	/*
	amt1_tot = AddUtil.parseInt(amt)*0.002; //등록세
	amt2_tot = AddUtil.parseInt(amt)*0.004; //증지세
	
	loan_amt1 = (int) amt1_tot;
	loan_amt1 = AddUtil.l_th_rnd(loan_amt1);
	loan_amt2 = (int) amt2_tot;
	loan_amt2 = AddUtil.l_th_rnd(loan_amt2);
	*/
	String reg_dt = Util.getDate();


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
	
	//외환캐피탈|| 효성캐피탈 || 하나은행 || 하나캐피탈 ||외환은행 || 우리파이낸셜  라인수 강제조정
	if ( FineDocBn.getGov_id().equals("0057") || FineDocBn.getGov_id().equals("0018") || FineDocBn.getGov_id().equals("0026") || FineDocBn.getGov_id().equals("0039") ||  FineDocBn.getGov_id().equals("0040") || FineDocBn.getGov_id().equals("0038") || FineDocBn.getGov_id().equals("0004") || FineDocBn.getGov_id().equals("0039") || FineDocBn.getGov_id().equals("0001") || FineDocBn.getGov_id().equals("0009") || FineDocBn.getGov_id().equals("0003") || FineDocBn.getGov_id().equals("0043") || FineDocBn.getGov_id().equals("0041") || FineDocBn.getGov_id().equals("0044") || FineDocBn.getGov_id().equals("0002") || FineDocBn.getGov_id().equals("0051") || FineDocBn.getGov_id().equals("0055")  || FineDocBn.getGov_id().equals("0059") || FineDocBn.getGov_id().equals("0058")  || FineDocBn.getGov_id().equals("0060")  || FineDocBn.getGov_id().equals("0037") || FineDocBn.getGov_id().equals("0011")  || FineDocBn.getGov_id().equals("0063") || FineDocBn.getGov_id().equals("0028")  || FineDocBn.getGov_id().equals("0064")  || FineDocBn.getGov_id().equals("0033")   || FineDocBn.getGov_id().equals("0065")   || FineDocBn.getGov_id().equals("0029")     || FineDocBn.getGov_id().equals("0025")   || FineDocBn.getGov_id().equals("0068")   ) {
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
<script language='javascript'>
<!--
	function onprint(){
	//저당권설정료 영수증 유무
	if(confirm('저당권설정료 영수증 첨부서류가 있습니까?')){
		tr_file_yn.style.display		= '';
	}else{
		tr_file_yn.style.display		= 'none';
	}
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 12.0; //좌측여백   
		factory.printing.rightMargin 	= 12.0; //우측여백
		factory.printing.topMargin 	= 20.0; //상단여백    
		factory.printing.bottomMargin 	= 30.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}
//-->
</script>
</head>
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
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
            <td height="25" width="87%" style="font-size : 10pt;"><font face="바탕"><%=FineDocBn.getDoc_id()%>1</font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">발신일자</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%if(FineDocBn.getReq_dt().equals("")){%><%=AddUtil.getDate3(reg_dt)%><%}else{%><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%><%}%></font></td>
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
            <td height="25" style="font-size : 10pt;"><font face="바탕">자동차 근저당권 설정 비용 입금 요청</font></td>
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
      <td width="87%" height="30" style="font-size : 10pt;"><font face="바탕">1. 귀 사의 무궁한 발전을 기원합니다.</font></td>
    </tr>
    <tr> 
      <td align='center' height="30" style="font-size : 10pt;"><font face="바탕">&nbsp;</font></td>
      <td height="30" style="font-size : 10pt;"><font face="바탕">2. 귀 사의 대출거래에서 아래와 같이 자동차 근저당권설정비용이 발생하였으니
        </font></td>
    </tr>
    <tr> 
      <td height="30" colspan="2" style="font-size : 10pt;"><font face="바탕"> 입금바랍니다.
        </font></td>
    </tr>
   
    <tr> 
      <td colspan=2 align='center' height="50" style="font-size : 9pt;"><font size="2" face="바탕">== 아&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;래 
        ==</font></td>
    </tr>
	<tr> 
      <td height="2" colspan="2" align="right" style="font-size : 8pt;"><font face="바탕">(단위:원)</font></td>
    </tr>
    <tr bgcolor="#000000"> 
		<td colspan="2" align='' height="10">
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<tr bgcolor="#A6FFFF" align="center"> 
					<td style="font-size : 8pt;" width="20%" height="<%=line_h%>"><font face="바탕">대출실행일</font></td>
					<td style="font-size : 8pt;" width="10%"><font face="바탕">차량대수</font></td>
					<td style="font-size : 8pt;" width="18%"><font face="바탕">근저당권설정액</font></td>
					<td style="font-size : 8pt;" width="16%"><font face="바탕">등록세</font></td>
					<td style="font-size : 8pt;" width="16%"><font face="바탕">증지세</font></td>
					<td style="font-size : 8pt;" width="20%"><font face="바탕">소계</font></td>
				</tr>
			</table>
		</td>
    </tr>
    <tr> 
      <td height="2" colspan="2"></td>
    </tr>
<% if(FineList.size()>0){
          		
		for(int i=0; i<FineList.size(); i++){ 
			FineDocListBn = (FineDocListBean)FineList.elementAt(i); 

			for(int j=0; j<1; j++){
				//저당권금액 저장 - 20120503	
				t_amt4[j] += AddUtil.parseLong(String.valueOf(FineDocListBn.getAmt6()));		
			
			}				
		}
	}
%>
<%
	amt = t_amt4[0];
	

	amt1_tot = amt*0.002; //등록세
	amt2_tot = amt*0.004; //증지세
	
	loan_amt1 = (int) amt1_tot;
	loan_amt1 = AddUtil.l_th_rnd(loan_amt1);
	loan_amt2 = (int) amt2_tot;
	loan_amt2 = AddUtil.l_th_rnd(loan_amt2);

	//근저당권설정 공문 DATA 수정
	if(FineDocBn.getReq_dt().equals("")){
//System.out.println("req_dt: "+FineDocBn.getReq_dt());		
		FineDocDb.changeReq_dt(doc_id, user_id, Util.parseDigit(Util.parseDecimal(loan_amt1)), Util.parseDigit(Util.parseDecimal(loan_amt2)));
	}

%>
  <table width='670' height="<%//=table2_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr bgcolor="#000000">
		<td width="100%" height="10" align='center'>
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<tr bgcolor="#FFFFFF" align="center">
					<td width="20%" height="<%=line_h%>" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕"><%=AddUtil.getDate3(FineDocBn.getEnd_dt())%></font></td>
					<td width="10%" style="font-size : 8pt;"><font face="바탕"><%=cnt%></font></td>
					<td width="18%" style="font-size : 8pt;" align=right><font face="바탕"><input type="text" name="t_amt4" value="<%=AddUtil.parseDecimal(t_amt4[0] )%>" size="10" style="border:none; text-align:right;" ></font>&nbsp;</font></td> 
					<td width="16%" style="font-size : 8pt;" align=right><font face="바탕"><input type="text" name="loan_amt1" value="<%=AddUtil.parseDecimal(loan_amt1)%>" size="8" style="border:none; text-align:right;"></font>&nbsp;</td>
					<td width="16%" style="font-size : 8pt;" align=right><font face="바탕"><input type="text" name="loan_amt2" value="<%=AddUtil.parseDecimal(loan_amt2)%>" size="8" style="border:none; text-align:right;"></font>&nbsp;</td>
					<td width="20%" style="font-size : 8pt;" align=right><font face="바탕"><input type="text" name="loan_tot" value="<%=AddUtil.parseDecimal(loan_amt1 + loan_amt2)%>" size="10" style="border:none; text-align:right;"></font>&nbsp;</td>
				</tr>
					<td colspan='3' width="50%" height="<%=line_h%>" bgcolor="#FFFFFF" align='center' style="font-size : 8pt;"><font face="바탕">입금계좌 : 예금주 (주)아마존카</font></td>
					<td colspan='3' width="50%" height="<%=line_h%>" bgcolor="#FFFFFF" style="font-size : 8pt;" align='center'><font face="바탕">
					<%if(FineDocBn.getGov_id().equals("0037")){%>
					산업은행 022-0209-6660-310
					<%}else{%>
					<input type="text" name="bank_num" value="신한은행 140-004-023871" size="40" style="border:none;">
					<%}%>
					</font></td>
				</tr>
				
			</table>
		</td>
    </tr>
  </table>
  <table width='670' height="<%=height%>" border="0" cellpadding="0" cellspacing="0">
	<tr> 
      <td colspan=2 height="20"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr bgcolor="#FFFFFF" align="center">
		
	</tr>
    <tr> 
      <td colspan=2 align='right' height="20" style="font-size : 10pt;"><font face="바탕">- 끝 -</font></td>
    </tr>
    <tr> 
      <td colspan=2 height="20"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr id=tr_file_yn style='display:none'> 
      <td colspan=2 height="20" style="font-size : 10pt;"><font face="바탕"># 첨&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 부 : 저당권설정료 영수증</font></td>
    </tr>
    <tr> 
      <td width="13%" height="20" style="font-size : 10pt;"><font face="바탕">&nbsp;</font></td>
      <td width="87%" height="20" style="font-size : 10pt;"><font face="바탕"> </font></td>
    </tr>
    <tr> 
      <td colspan="2"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr align="center"> 
      <td height="40" colspan="2" style="font-size : 19pt;"><font face="바탕"><b>주식회사 
        아마존카 대표이사 조&nbsp;&nbsp;성&nbsp;&nbsp;희</b></font></td>
    </tr>
  </table>
</table>
</form>
</body>
</html>
