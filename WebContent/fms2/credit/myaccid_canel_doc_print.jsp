<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	
	String m_id = "";//계약관리번호
	String l_cd = "";//계약번호
	String c_id = "";//자동차관리번호
	String accid_id = "";//사고관리번호
	
	String pay_dt = ""; //입금일
	String pay_amt = ""; //입금액
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	String due_dt = c_db.addDay(FineDocBn.getEnd_dt(), 1);
		
	//연체리스트
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);
	
	String rent_st = "";
	int cls_per = 0;
	
	int start_dt = 0;	
	
	long amt3[]   = new long[9];
	
	int amt_1 = 0;
	int amt_2 = 0;
	int amt_3 = 0;
	int amt_4 = 0;
	int amt_5 = 0;
	int amt_6 = 0;
	int amt_7 = 0;
	long amt_i = 0;
	
	int	tot_amt = 0;
	int	tot_amt2 = 0;
	int	tot_amt3 = 0;
	
	//인쇄여부 수정
	if(FineDocBn.getPrint_dt().equals("")){
		FineDocDb.changePrint_dt(doc_id, user_id);
	}
		
	int app_doc_h = 0;
	String app_doc_v = "";
					
	//내용 라인수
	int tot_size =  FineList.size();
		
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
    
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
		
	function onprint(){
		var userAgent = navigator.userAgent.toLowerCase();
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			IE_Print();
		}
		/* factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 20.0; //좌측여백   
		factory.printing.rightMargin 	= 12.0; //우측여백
		factory.printing.topMargin 	= 20.0; //상단여백    
		factory.printing.bottomMargin 	= 20.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임 */
	}
	
function IE_Print() {
	factory1.printing.header = ""; //폐이지상단 인쇄
	factory1.printing.footer = ""; //폐이지하단 인쇄
	factory1.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
 	factory1.printing.leftMargin = 20.0; //좌측여백   
 	factory1.printing.rightMargin = 12.0; //우측여백
 	factory1.printing.topMargin = 20.0; //상단여백    
 	factory1.printing.bottomMargin = 20.0; //하단여백
	factory1.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}

function onprint(){
	
}
//-->
</script>
</head>
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<form action="" name="form1" method="POST" >
<div id="Layer1" style="position:absolute; left:565px; top:900px; width:109px; height:108px; z-index:1"><img src="/images/square.png" width="109" height="108"></div>
<table width='640' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0">
	<tr>
    	<td height=10></td>
	</tR>
    <tr> 
        <td colspan="2" height="40" align="center" style="font-size : 20pt;"><b><u><font face="바탕">대차료 차액분 납부최고</font></u></b></td>
    </tr>
    <tr> 
      <td colspan="2" height="50" align="center"></td>
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
            <td height="25" style="font-size : 10pt;"><font face="바탕">발신일자</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 신</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=FineDocBn.getGov_nm()%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"></td>
            <td height="25" style="font-size : 10pt;"></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=FineDocBn.getGov_addr()%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">발&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 신</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">(주)아마존카 대표이사 조성희</font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕"></font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"></font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">서울시 영등포구 의사당대로 8 태흥빌딩 8층</font></td>
          </tr>
        
        </table></td>
    </tr>
    <tr> 
      <td height="7" colspan="2" align='center'></td>
    </tr>
    <tr> 
      <td colspan=2 align='center' style="height:2; background-color:#999999"></td>
    </tr>
    <tr> 
      <td height="10" colspan="2" align='center'></td>
    </tr> 
	<tr>
	    <td height=10></td>
	</tR>
    <tr>
        <td align=center>
            <table width=628 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height="25" style="font-size : 10pt;"><p><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. 귀사의 무궁한 발전을 기원합니다.</font></p>
                    <p>&nbsp;</p></td>
                </tr>
                <tr>
                   <td height="25" style="font-size : 10pt;"><p><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. 주지하다시피 당사는 첨부와 같이 귀사 보험가입자와 당사 차량이용자간의 차량사고 건으로 인해 발생된 대차료를 첨부와 같이 귀사에 청구하였습니다.</font></p>
                   <p>&nbsp;</p></td>
                </tr>
                <tr>
                   <td height="25" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. 그런데 귀사에 청구한 대차료 청구분과 실제 귀사가 입금한 금액과의 차이가 있어 이를 알려드리며, 발생한 차액과 이자를 합산한 금액에 대하여 아래와 같이 납부하여 주실 것을 최고합니다. (이자는 일부금액을 입금한 날로부터 최고일까지, 차액에 대한 연5%의 비율로 계산하였습니다. 단, 일부금액도 입금되지 않은 건은 청구일을 기산일로 하여 계산되었습니다.)</font></td>
                </tr>
                <tr>
                    <td>&nbsp;                  </td>
                </tr>
            	<tr>
                    <td height=10></td>
                </tR>
<% if(FineList.size()>0){
			for(int i=0; i<FineList.size(); i++){ 
				FineDocListBn = (FineDocListBean)FineList.elementAt(i); 
				if(FineDocListBn.getAmt5()==0){
					FineDocListBn.setAmt5(FineDocListBn.getAmt3());
				}
				amt_3 += FineDocListBn.getAmt5();

			}
		}%>	
                <tr>
                    <td>
                        <table width=628 border=0 cellspacing=1 cellpadding=0 bgcolor=000000>
                            <tr bgcolor=ffffff>
                                <td style="font-size : 9pt;" width=135 align=center bgcolor=ffffff height=40><font face="바탕">대차료 차액분 총계 </font></td>
                                <td style="font-size : 9pt;" width=176 align=center bgcolor=ffffff>&nbsp;<span class=style12><font face="바탕"><%=Util.parseDecimal(amt_3)%>원</font></span></td>
                                <td style="font-size : 9pt;" width=135 align=center bgcolor=ffffff><span class=style10><font face="바탕">납부기한</font></span></td>
                                <td style="font-size : 9pt;" width=177 align=center bgcolor=ffffff>&nbsp;<span class=style12><font face="바탕"><%=AddUtil.getDate3(FineDocBn.getEnd_dt())%></font></span></td>
                            </tr>
                            <tr bgcolor=#FFFFFF>
                                <td style="font-size : 9pt;" height=40 align=center bgcolor=ffffff><span class=style10><font face="바탕">입금계좌번호</font></span></td>
                                <td style="font-size : 9pt;" bgcolor=#ffffff colspan=3 align='center'><span class=style12>&nbsp;<font face="바탕">신한 140-004-023863</font></span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height="25" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. 만일 귀사가 상기 납부일까지 대차료 차액분을 납부하지 않을 경우, &nbsp;&nbsp;당사에 실제 발생된 손해, 즉 대차 손해를 보전코자 민사적인 법적절차를 진행하고, 이에 따르는 제비용을 별도 청구할 예정이오니, 첨부 사고건과 관련하여 발생된 대차료 청구분에 대하여 당사에 전액 납부하여 주실 것을 당부 드립니다. </font></td>
                </tr>
                <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height=10></td>
                </tR>
                 <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height=10></td>
                </tR>
                 <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height=10></td>
                </tR>
                 <tr>
                    <td height="25" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;※ 첨부 : 대차료 청구리스트 각 1 부</font></td>
                </tr>
                <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height="25" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;※ 문의처 : 법무담당 장혁준 02-6263-6383</font></td>
                </tr>
                <tr>
                    <td height=10></td>
                </tR>
             <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height=10></td>
                </tR>
                 <tr>
                    <td height=10></td>
                </tR>
                <tr>
                    <td height=10></td>
                </tR>
                </table>
		      </td>
        	</tr>
	    </td>
	</tr>
	<tr> 
      <td colspan="2"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr align="center"> 
      <td height="40" colspan="2" style="font-size : 19pt;"><font face="바탕"><b>주식회사 
        아마존카 대표이사 조&nbsp;&nbsp;성&nbsp;&nbsp;희</b></font></td>
    </tr>
    <tr>
        <td height=10></td>
    </tR>
    <tr>
        <td height=10></td>
    </tR>
</table>
					
<table width='695' height="" border="0" cellpadding="0" cellspacing="0">
	<tr> 
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대차료 청구리스트</span></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
         <tr> 
            <td class='title' width="4%">연번</td>
            <td class='title' width="9%">사고차량</td>
            <td class='title' width="9%">대차차량</td>
    	    <td class='title' width="8%">사고구분</td>
            <td class='title' width="9%">사고일자</td>
            <td class='title' width="9%">청구일자</td>						
            <td class='title' width="9%">청구액</td>									
            <td class='title' width="9%">입금일자</td>												
            <td class='title' width="9%">입금액</td>
            <td class='title' width="9%">차액</td>
            <td class='title' width="7%">이자</td>
            <td class='title' width="9%">계</td>
            
          </tr>
  <% 	
			Vector vt = FineDocDb.getMyAccidDocLists_2(doc_id);
			int vt_size = vt.size();
			
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
					
					tot_amt += AddUtil.parseInt(String.valueOf(ht.get("AMT5")));
					
					tot_amt2 += AddUtil.parseInt(String.valueOf(ht.get("AMT3")));
					
					tot_amt3 += AddUtil.parseInt(String.valueOf(ht.get("AMT4")));
					
				
					%>		  
          <tr align="center"> 
            <td><%=i+1%></td>
            <td><%=ht.get("OUR_CAR_NO")%></td>			
            
            <td><%=ht.get("CAR_NO")%></td>			
            <td><%=ht.get("ACCID_ST")%></td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACCID_DT")))%></td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT1"))%></td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT2"))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT3"))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT4"))%></td>
            <td align='right'><%=Util.parseDecimal(ht.get("AMT5"))%></td>
          </tr>
          <% 	}
			} %>
			<tr>
				<td colspan="9" align='center'>합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계</td>
				<td align='right'><%=Util.parseDecimal(tot_amt2)%></td>
				<td align='right'><%=Util.parseDecimal(tot_amt3)%></td>
				<td align='right'><%=Util.parseDecimal(tot_amt)%></td>
			</tr>
        </table>
      </td>
    </tr>
</table>

<table width='695' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0">
  <% 	

	
		Vector vt2 = FineDocDb.getMyAccidDocLists_2(doc_id);
		int vt2_size = vt2.size();
        if(vt2_size > 0){
				for(int i=0; i<vt2.size(); i++){ 
					Hashtable ht2 = (Hashtable)vt2.elementAt(i);

				accid_id = String.valueOf(ht2.get("ACCID_ID"));
				m_id = String.valueOf(ht2.get("RENT_MNG_ID"));
				l_cd = String.valueOf(ht2.get("RENT_L_CD"));
				c_id = String.valueOf(ht2.get("CAR_MNG_ID"));				
				pay_dt = String.valueOf(ht2.get("RENT_END_DT"));
				pay_amt = String.valueOf(ht2.get("AMT2"));
			
					%>
	<tr>
		<td colspan=2>
		<% if ( i % 2 == 0 ) {%>
		<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
		<% } %>
		<iframe src="accid_cb.jsp??auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&pay_dt=<%=pay_dt%>&pay_amt=<%=pay_amt%>&mode=8";" name="i_no" width="695" height="<%=table1_h%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>

		</td>
	</tr>
<% 	}
} %>						
</table>

</form>
</body>
</html>
