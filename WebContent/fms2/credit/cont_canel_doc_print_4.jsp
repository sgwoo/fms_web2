<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	String due_dt = c_db.addDay(FineDocBn.getEnd_dt(), 0);
	String due_dt2 = c_db.addDay(FineDocBn.getEnd_dt(), 1);
		
	//연체리스트
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);
	
	String rent_st = "";
	int cls_per = 0;
	int de_day = 0;
	
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
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=12;
		IEPageSetupX.rightMargin=12;
		IEPageSetupX.topMargin=20;
		IEPageSetupX.bottomMargin=10;	
	<%if(FineDocBn.getPrint_dt().equals("")){%>
		print();
	<%}%>
	}
	
function IE_Print() {
	factory1.printing.header = ""; //폐이지상단 인쇄
	factory1.printing.footer = ""; //폐이지하단 인쇄
	factory1.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
 	factory1.printing.leftMargin = 12.0; //좌측여백   
 	factory1.printing.rightMargin = 12.0; //우측여백
 	factory1.printing.topMargin = 20.0; //상단여백    
 	factory1.printing.bottomMargin = 10.0; //하단여백
	factory1.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}

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
}
//-->
</script>
</head>
<body leftmargin="10" topmargin="1" onLoad="javascript:onprint();" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form action="" name="form1" method="POST" >
  <table width='640' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr> 
        <td colspan="2" height="40" align="center" style="font-size : 20pt;"><b><u><font face="바탕">계약해지 및 차량반납통보</font></u></b></td>
    </tr>

 <!--  
     <tr> 
      <td colspan="2" height="1" align="center" bgcolor=000000></td>
    </tr>
 -->   
    
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
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=FineDocBn.getGov_nm()%>&nbsp;<%=FineDocBn.getMng_dept()%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"></td>
            <td height="25" style="font-size : 10pt;"></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=FineDocBn.getGov_addr()%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">발&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 신</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">(주)아마존카</font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕"></font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"></font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">서울시 영등포구 의사당대로 8 태흥빌딩 8층</font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 목</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=FineDocBn.getTitle()%>&nbsp;</font></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="7" colspan="2" align='center'></td>
    </tr>
    <tr bgcolor="#999999"> 
      <td colspan=2 align='center' height="2" bgcolor="#333333"></td>
    </tr>
    <tr> 
      <td height="10" colspan="2" align='center'></td>
    </tr>  
    <tr>
        <td align=center>
            <table width=628 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height="25" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. 당사는 귀사(귀하)와 원만한 거래관계가&nbsp; 지속되도록 최선의 노력을 다해왔으나, &nbsp;이 건 <b>계약 해지 및 차량반납통보</b>를 보내게 되었음을 유감스럽게 생각합니다.</font></td>
                </tr>
                 <tr>
                    <td height=10></td>
                </tr>
                <tr>
                   <td height="25" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. 주지하다시피 아래와 같이 귀사(귀하)와의 사이에 자동차대여이용계약을 체결하였습니다.</font></td>
                </tr>
                <tr>
                    <td>
                        <table width=628 border=0 cellspacing=1 cellpadding=0 bgcolor=000000>
                            <tr>
                                <td width=105  style="font-size : 9pt;" rowspan=2 align=center bgcolor=ffffff><span class=style10><font face="바탕">차명</font></span></td>
                                <td width=96 style="font-size : 9pt;" rowspan=2 align=center bgcolor=ffffff><span class=style10><font face="바탕">차량번호</font></span></td>
                                <td height=22 style="font-size : 9pt;" colspan=3 align=center bgcolor=ffffff><span class=style10><font face="바탕">대여이용계약기간</font></span></td>
                                <td width=75 style="font-size : 9pt;" rowspan=2 align=center bgcolor=ffffff><span class=style10><font face="바탕">보증금</font></span></td>
                                <td width=75 style="font-size : 9pt;" rowspan=2 align=center bgcolor=ffffff><span class=style10><font face="바탕">개시대여료</font></span></td>
                                <td width=72 style="font-size : 9pt;" rowspan=2 align=center bgcolor=ffffff><span class=style10><font face="바탕">월대여료</font></span></td>
                            </tr>
                            <tr bgcolor=#FFFFFF>
                                <td width=75 style="font-size : 9pt;" height=22 align=center bgcolor=ffffff><span class=style10><font face="바탕">개시일</font></span></td>
                                <td width=75 style="font-size : 9pt;" align=center bgcolor=ffffff><span class=style10><font face="바탕">종료일</font></span></td>
                                <td width=52 style="font-size : 9pt;" align=center bgcolor=ffffff><span class=style10><font face="바탕">비고</font></span></td>
                            </tr>
<% if(FineList.size()>0){
			for(int i=0; i<FineList.size(); i++){ 
				FineDocListBn = (FineDocListBean)FineList.elementAt(i); 
						
				Hashtable base1 = as_db.getSettleBase(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd(), "", "");
				de_day  =	AddUtil.parseInt((String)base1.get("S_MON")) * 30  +   AddUtil.parseInt((String)base1.get("S_DAY")); 
											
				//cont
				Hashtable base = a_db.getContViewCase(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
				
				rent_st = FineDocDb.getMaxRentSt(FineDocListBn.getRent_l_cd());
				
				ContFeeBean fee = a_db.getContFeeNew(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd(), rent_st);
				
				ContEtcBean cont_etc = a_db.getContEtc(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
				
				cls_per = (int) fee.getCls_r_per();
		
				amt_6 += FineDocListBn.getAmt6();
			
			

%>	
                            <tr bgcolor=#FFFFFF>
                                <td style="font-size : 9pt;" height=25 align=center bgcolor=#FFFFFF><span class=style12><font face="바탕"><%=base.get("CAR_NM")%></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=#FFFFFF><span class=style11><font face="바탕"><%=base.get("CAR_NO")%></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=#FFFFFF><span class=style12><font face="바탕"><%=base.get("RENT_START_DT")%></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=#FFFFFF><span class=style12><font face="바탕"><%=base.get("RENT_END_DT")%></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=#FFFFFF><span class=style12><font face="바탕"><%=base.get("CON_MON")%>개월</font></span></td>
                                <td style="font-size : 9pt;" align=right bgcolor=#FFFFFF><span class=style12><font face="바탕"><%=Util.parseDecimal(fee.getGrt_amt_s())%>&nbsp;</font></span></td>
                                <td style="font-size : 9pt;" align=right bgcolor=#FFFFFF><span class=style12><font face="바탕"><%=Util.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>&nbsp;</font></span></td>
                                <td style="font-size : 9pt;" align=right bgcolor=#FFFFFF><span class=style12><font face="바탕"><%=Util.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>&nbsp;</font></span></td>
                               
                            </tr>
<%
start_dt = AddUtil.ChangeStringInt(String.valueOf(base.get("RENT_START_DT")));
if(!cont_etc.getRent_suc_dt().equals("")){
	start_dt = AddUtil.parseInt(cont_etc.getRent_suc_dt());	
}
%>                                
<% 		}
} %>                                                    
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
	                <td>
	                    <table width=628 border=0 cellspacing=1 cellpadding=0 bgcolor=000000>
	                        <tr bgcolor=ffffff>
	                            <td style="font-size : 9pt;" width=105 align=center bgcolor=ffffff height=25><span class=style10><font face="바탕">중도해지조건</font></span></td>
	                            <td style="font-size : 9pt;" colspan=3 bgcolor=ffffff>&nbsp;<span class=style12><font face="바탕">월대여료를 30일 이상 연체할 시 계약의 해지 및 대여중인 차량을 회수</font></span></td>
	                        </tr>
	                        <tr bgcolor=#FFFFFF>
	                            <td style="font-size : 9pt;" height=25 align=center bgcolor=ffffff><span class=style10><font face="바탕">연체이자율</font></span></td>
	                            <td style="font-size : 9pt;" align=center bgcolor=#FFFFFF width=214><span class=style12><font face="바탕"><%if(start_dt < 20081010 ) {%>연 18%<%}else if(start_dt >= 20081010 && start_dt < 20220101) {%>연 24%<%}else{%>연 20%<%}%></font></span></td>
	                            <td style="font-size : 9pt;" align=center bgcolor=ffffff width=80><span class=style10><font face="바탕">위약금</font></span></td>
	                            <td style="font-size : 9pt;" align=center bgcolor=#FFFFFF width=244><span class=style12><font face="바탕">잔여기간 대여료 총액의 (<%=cls_per%>)%</font></span></td>
	                        </tr>
	                    </table>
	                </td>
	            </tr>
	             <tr>
	                <td height=10></td>
	            </tr>
	            <tr>
	                 <td height="25" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. 그런데,&nbsp; 귀사(귀하)가 대여료를 (&nbsp;<b><%=de_day%></b>&nbsp;)일 이상 납부하지 않고 있어서&nbsp; 당사는 &nbsp;귀사(귀하)와 더 이상의 계약관계를 유지할 수
없으며 상기 중도해지 규정을 적용하여 해지를 통보합니다. </font></td>
	            </tr>
	            <tr>
	                <td height=10></td>
	            </tr>
	            <tr>
	                 <td height="25" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. 귀사(귀하)의 <b><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></b>&nbsp;현재 해지정산금은&nbsp;(&nbsp;<b><%=Util.parseDecimal(amt_6)%></b>&nbsp;) 원 입니다. </font></td>
	            </tr>
                <!--<tr>
                    <td>
                        <table width=628 border=0 cellspacing=1 cellpadding=0 bgcolor=000000>
                       
                            <tr bgcolor=#FFFFFF>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2 height=25><span class=style10><font face="바탕">해지정산금</font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2>&nbsp;<span class=style12><font face="바탕"><%=Util.parseDecimal(amt_6)%> 원&nbsp;</font></span></td>
                            </tr>
                         </table>
                    </td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td align=right colspan=4  style="font-size : 9pt;"><span class=style12><font face="바탕">* 상기 해지정산금은 차량 회수일까지 변동됨을 알려드립니다.</font></span></td>
                </tr>-->
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td height="25" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5. 아래 일시까지 차량을 반납할 것을 통보하며, 반납 하지 않을 경우 귀사(귀하)에게  모든 <b>법적 책임(횡령죄로 형사 고소등)</b>을 물을 것입니다.</font></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td>
                        <table width=628 border=0 cellspacing=1 cellpadding=0 bgcolor=000000>
                            
                           <tr bgcolor=ffffff>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2 height=25><span class=style10><font face="바탕"><b>차량반납기한</b></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2>&nbsp;<span class=style12><font face="바탕"><b><%=AddUtil.getDate3(due_dt)%></b></font></span></td>
								<td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2 height=25><span class=style10><font face="바탕"><b>법적절차진행예정일</b></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2>&nbsp;<span class=style12><font face="바탕"><b><%=AddUtil.getDate3(due_dt2)%></b></font></span></td>
                          </tr>
                           
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=15></td>
                </tr>
                <tr>
                    <td height="25" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6. 위 일시까지 차량반납이 안될시 당사는 귀사(귀하)와 연대보증인을 상대로 민·형사상 법적구제절차및 자구행위를 진행하고, 이에 따르는 제비용(가압류, 임의경매 등의 소송관련 제비용,&nbsp; 차량회수 등
업무위탁에 따른 제비용 등 포함)을 별도 청구할 예정이며, 경우에 따라 보증보험청구 및 신용정보기관에 채권 추심의뢰와 채무불이행 정보를 등록할 것이며, 채무불이행 정보 등록 시 개인 신용 평점 또는 기업신용등급이 하락하고 금리가 상승하는 등의 불이익이 발생 할 수 있음을 알려드립니다.
<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>
                </tr>
              
                <tr>
                    <td height=30></td>
                </tR>
                <tr>
                    <td height="25" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;<span class=style7>※ 문의처 : 법무담당 장혁준 02-6263-6383</span></font></td>
                </tr>
                <tr>
                    <td height=40></td>
                </tr>
               <tr>
                    <td height=10></td>
                </tr>
                <!--
                <tr>
			        <td align="center" height="25" style="font-size : 10pt;"><font face="바탕"><span class=style12>"이미 납부하셨다면 정중히 사과 드리며, 본 안내장은 폐기해 주시길 바랍니다."</span></font></td>
			    </tr>
               -->
                </table>
            </td>
        </tr>

    </td>
</tr>
</table>
<div style="position:relative">
<div id="Layer1" style="position:absolute; left:480px; top:30px; width:109px; height:108px; z-index:1"><img src="/images/square.png" width="109" height="108"></div>
<div style="position:relative; z-index:2;" >
<table width='640' height="100" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td colspan="2"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr align="center"> 
      <td height="40" colspan="2" style="font-size : 18pt;"><font face="바탕"><b>주식회사 
        아마존카 대표이사 조&nbsp;&nbsp;성&nbsp;&nbsp;희</b></font></td>
    </tr>
</table>
</div>
</div>
</form>
</body>
</html>
