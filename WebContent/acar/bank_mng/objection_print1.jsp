<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
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
	
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
		//대출신청리스트
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
    long t_amt4[] = new long[1];
 //   long t_amt5[] = new long[1];
    long t_amt6[] = new long[1];
    long t_amt7[] = new long[1];
    long t_amt8[] = new long[1];
    
    String gov_chk_id = "";
	
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
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<form action="" name="form1" method="POST" >
  <table width='1440' border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="100%" height="30" align="left" style="font-size : 10pt;"><font face="바탕"># 첨부: 세부 내역서</font></td>
    </tr>
    <tr> 
      <td height="10" align="center"></td>
    </tr>	
    <tr bgcolor="#000000"> 
      <td align='center'> 
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr  bgcolor="#000000"> 
            <td> 
	  <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr bgcolor="#FFFFFF" align="center">
                  <td height="30" width="3%"  rowspan="3" style="font-size : 10pt;"><font face="바탕">구분</font></td>
                  <td height="30" width="35%" colspan="7" style="font-size : 10pt;"><font face="바탕">자동차대여계약내용</font></td>
                  <td height="30" width="30%" colspan="6" style="font-size : 10pt;"><font face="바탕">자동차구입내용</font></td>
                
                </tr>
                <tr bgcolor="#FFFFFF" align="center">
                  <td height="25" colspan="2" style="font-size : 10pt;"><font face="바탕">고객사항</font></td>
                  <td height="25" colspan="3" style="font-size : 10pt;" ><font face="바탕">계약사항</font></td>
                  <td height="25" width="6%" rowspan="2" style="font-size : 10pt;"  ><font face="바탕">보증금/<br>선납금</font></td>
                   <td height="25" width="20%" rowspan="2" style="font-size : 10pt;"  ><font face="바탕">주소</font></td>
                  <td height="25" colspan="2" style="font-size : 10pt;"><font face="바탕">자동차사항</font></td>
                  <td height="25" colspan="4" style="font-size : 10pt;"><font face="바탕">구입가격(명세)</font></td>
                
                </tr>
                <tr bgcolor="#FFFFFF" align="center">
                  <td width="8%" height="25" style="font-size : 10pt;"><font face="바탕">상호/성명</font></td>
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="바탕">사업자번호</font></td>
                  <td width="4%" height="25" style="font-size : 10pt;"><font face="바탕">계약기간(월)</font></td>
                  <td width="5%" height="25" style="font-size : 10pt;"><font face="바탕">월대여료</font></td>
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="바탕">총대여료</font></td>
                  <td width="7%" height="25" style="font-size : 10pt;"><font face="바탕">차종</font></td>
                  <td width="5%" height="25" style="font-size : 10pt;"><font face="바탕">차량번호</font></td>
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="바탕">공급가</font></td>
                   <td width="6%" height="25" style="font-size : 10pt;"><font face="바탕">부가세</font></td>
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="바탕">구입가격</font></td>
                  <td width="6%" height="25" style="font-size : 10pt;"><font face="바탕">출고예정일</font></td>
            
                </tr>
             
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="2" align="center"></td>
    </tr>	
    <tr bgcolor="#000000">
     <td width="100%" height="10" align='center'><table width="100%" border="0" cellspacing="1" cellpadding="0">
          <% if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					Hashtable ht = (Hashtable)FineList.elementAt(i);
					
					gov_chk_id = String.valueOf(ht.get("GOV_ID"));
				
					for(int j=0; j<1; j++){
						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT1"))); //대여료
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT2"))); //총대여료
						t_amt3[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT3")));	//구매가격
						t_amt4[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT4")));	//대출금액(대구은행은 차량공급가)
			//			t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("CAR_F_AMT")));	//소비자가격
						t_amt6[j] += AddUtil.parseLong(String.valueOf(ht.get("PRE_AMT")));	//선납금액
						t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT5")));	//취득세
						t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("DAM_AMT")));	//삼성담보시 사용할 금액
					}			
					
		%>
          <tr bgcolor="#FFFFFF" align="center">
            <td  width="3%" height="30" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕"><%=i+1%></font></td>
            <td  width="8%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("FIRM_NM")%></font></td>
            <td  width="6%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("ENP_NO")%></font></td>
            <td  width="4%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("PAID_NO")%></font></td>
            <td  width="5%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("AMT1"))%></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("AMT2"))%></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("PRE_AMT"))%></font></td>
            <td  width="20%" style="font-size : 8pt;" align=left><font face="바탕"><%=ht.get("O_ADDR")%></font></td>
            <td  width="7%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("CAR_NM")%></font></td>
            <td  width="5%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("CAR_NO")%></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("AMT4"))%></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("AMT3"))) - AddUtil.parseLong(String.valueOf(ht.get("AMT4"))) ) %></font></td>
            <td  width="6%" style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(ht.get("AMT3"))%></font></td>
            <td  width="6%" style="font-size : 8pt;"><font face="바탕"><%=ht.get("DLV_EST_DT")%></font></td>     
          
          </tr>
          <% 	} %>
         <tr bgcolor="#FFFFFF" align="center">
            <td  colspan=4 height="30"  bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕">합계</font></td>
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt1[0])%></font></td>
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt2[0])%></font></td>
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt6[0])%></font></td>
            <td  colspan=3 style="font-size : 8pt;"><font face="바탕"></font></td>        
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt4[0])%></td>
             <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt3[0]-t_amt4[0])%></td>
            <td  style="font-size : 8pt;" align=right><font face="바탕"><%=Util.parseDecimal(t_amt3[0])%></font></td>
            <td  style="font-size : 8pt;"><font face="바탕"></font></td>         
           
          </tr>
		<%} %>
      </table></td>
    </tr>
    <tr> 
      <td height="5" align="center"></td>
    </tr>	
    <tr> 
      <td height="25" style="font-size : 10pt;"><font face="바탕">*&nbsp;
      <% if ( gov_chk_id.equals("0018")  ||  gov_chk_id.equals("0041")   ||  gov_chk_id.equals("0011")  ||  gov_chk_id.equals("0055")  ||  gov_chk_id.equals("0069")   ||  gov_chk_id.equals("0072")    ) {%>
      대출금액의 20% 근저당 설정 
      <% } else { %>
      대출금액의 50% 근저당 설정
      <% } %>
      
      </font></td>
    </tr>	
  </table>
 
</form>
</body>
</html>
