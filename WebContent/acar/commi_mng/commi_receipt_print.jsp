<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.commi_mng.*, acar.car_office.*"%>
<jsp:useBean id="acm_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String st_year = request.getParameter("st_year")==null?Integer.toString(AddUtil.getDate2(1)):request.getParameter("st_year");//귀속연도
	
	String st_dt = st_year  + "0101";
	String end_dt = st_year + "1231";	
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");//영업사원  id
	String emp_acc_nm = request.getParameter("emp_acc_nm")==null?"":request.getParameter("emp_acc_nm");//실수령인
	
	//default:영업사원	
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp_id);
	
	Hashtable emp_i = acm_db.getEmpAccNm(emp_id, emp_acc_nm);	
	
			
	Vector commis = acm_db.getCommiList("", "9", "4", "2", "", st_dt, end_dt, "13", emp_acc_nm, "9", "0" , "", emp_id  );
	int commi_size = commis.size();

	int page_size = commi_size / 12 ;
	int list_size = commi_size % 12 ;
	
	int page_size1 = (commi_size  - 12)/ 40 ;
	int list_size1 =  (commi_size  - 12)  % 40 ;
	
//	System.out.println( "commi_size=" + commi_size )  ;
	
//	System.out.println( "page_size=" + commi_size / 12 )  ;
 //     System.out.println( "list_size=" + commi_size % 12 )  ;
         
  //       System.out.println( "page_size1=" +(commi_size  - 12)/ 40 )  ;
 //        System.out.println( "list_size1=" + ( commi_size  - 12)  % 40 )  ;
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 11; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height);//현황 라인수만큼 제한 아이프레임 사이즈
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>무제 문서</title>

<STYLE>
<!--
* {line-height:130%; font-size:10.0pt; font-family:돋움체;}


.style1 {border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style2 {border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style3 {border-right:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style4 {border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style5 {border-right:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style6 {border-left:solid #000000 1px;border-right:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style7 {border-left:solid #000000 1px;border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style8 {font-size:8.0pt; text-align:center;}


.f1{font-size:13pt; font-weight:bold; line-height:150%;}
.f2{font-size:10.5pt; line-height:150%;}
-->
</STYLE>

<script language="JavaScript" type="text/JavaScript">	

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
	
	function IE_Print() {
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 12.0; //좌측여백   
		factory.printing.rightMargin 	= 10.0; //우측여백
		factory.printing.topMargin 	= 15.0; //상단여백    
		factory.printing.bottomMargin 	= 12.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}

</script>

</head>

<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<%	if(page_size <1){%>	
<div id="Layer1" style="position:absolute; left:600px; top:690px; width:54px; height:41px; z-index:1"><img src="/acar/main_car_hp/images/stamp.png" width="75" height="75"></div>
<table width="700" border="0" cellspacing="2" cellpadding="0" bgcolor="#000000">
	<tr>
		<td bgcolor="#FFFFFF">
			<table width="700" border="0" cellspacing="0" cellpadding="0">
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0" height=90>
				            <tr>
				                <td valign=top>
				                	<TABLE border="0" cellspacing="0" cellpadding="0" style='border-collapse:collapse;border:none;'>
					                    <TR>
					                        <TD width="43" height="33" class=style3 align=center>귀속<br>연도</TD>
					                        <TD width="63" class=style6 align=right><%= st_year%>년</TD>
					                    </TR>
				                	</TABLE>
				                </td>
				                <td>
				                	<span class=f1>&nbsp;&nbsp;&nbsp;[&nbsp;] 거주자의 사업소득 원천징수영수증</span><br>
				                    <span class=f1>&nbsp;&nbsp;&nbsp;[&nbsp;] 거주자의 사업소득 지급명세서</span><br>
				                    <span class=f2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( <input name="checkbox" type="checkbox" value="checkbox" checked>소득자 보관용&nbsp;&nbsp;<input name="checkbox" type="checkbox" value="checkbox">발행자 보관용 )</span></td>
				                <td align=right>
				                	<TABLE border="0" cellspacing="0" cellpadding="0" style='border-collapse:collapse;border:none;'>
					                    <TR>
					                        <TD colspan="2" width="95" height="25" align="center" class=style7>내ㆍ외국인</TD>
					                        <TD colspan="2" width="105" align="center" class=style2><img src=/acar/images/receipt_img.gif></TD>
					                    </TR>
					                    <TR>
					                        <TD width="36" height="30" align="center" class=style7>거주지국</TD>
					                        <TD width="44" align="center" class=style7>&nbsp;</TD>
					                        <TD width="58" align="center" class=style7>거주지국코드</TD>
					                        <TD width="35" align="center" class=style4>&nbsp;</TD>
					                    </TR>
				                	</TABLE>
				                </td>
				            </tr>
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
				            <TR>
								<TD width="59" rowspan="2" align=center class=style1>징&nbsp; 수<br>의무자</TD>
								<TD width="90" height="34" class=style1>&nbsp;1.사업자<br>&nbsp;&nbsp; 등록번호</TD>
								<TD width="115" class=style1>&nbsp;128-81-47957</TD>
								<TD width="85" class=style1>&nbsp;2.법인명<br>&nbsp;&nbsp; 또는 상호</TD>
								<TD colspan="2" class=style1>&nbsp;(주)아마존카</TD>
								<TD width="50" class=style1>&nbsp;3.성명</TD>
							    <TD width="100" class=style2>&nbsp;조성희</TD>
				            </TR>
							<TR>
								<TD height="28" class=style3>&nbsp;4.주민(법인)<br>&nbsp;&nbsp; 등록번호</TD>
								<TD class=style3>&nbsp;115611-0019610</TD>
								<TD class=style3>&nbsp;5.소재지<br>&nbsp;&nbsp; 또는 주소</TD>
							    <TD colspan="4" class=style4>&nbsp;서울 영등포구 여의도동 17-3 까뮤이앤씨빌딩 8층</TD>
						    </TR>
							<TR>
								<TD rowspan="4" align=center class=style3>소득자</TD>
								<TD height="28" class=style3>&nbsp;6.상&nbsp;&nbsp;&nbsp;&nbsp;호</TD>
								<TD colspan="2" class=style3>&nbsp;</TD>
								<TD width="115" height="33" class=style3>&nbsp;7.사업자등록번호</TD>
								<TD colspan="3" class=style4>&nbsp;</TD>
						    </TR>
							<TR>
								<TD height="28" class=style3>&nbsp;8.사업장<br>&nbsp;&nbsp; 소재지</TD>
							    <TD colspan="6" class=style4>&nbsp;</TD>
						    </TR>
    <% if (  emp_acc_nm.equals("") ) {%>					    
							<TR>
								<TD style="height:28px" class=style3>9.&nbsp;성&nbsp;&nbsp;&nbsp;&nbsp;명</TD>
								<TD colspan="2" class=style3>&nbsp;<%=coe_bean.getEmp_nm()%></TD>
								<TD class=style3>10.주민등록번호</TD>
								<TD colspan="3" class=style4>&nbsp;<%= coe_bean.getEmp_ssn1() %> - <%= coe_bean.getEmp_ssn2() %></TD>
						    </TR>
							<TR>
								<TD style="height:28px" class=style3>11.주&nbsp;&nbsp;&nbsp;&nbsp;소</TD>
							    <TD colspan="6" class=style4>&nbsp;<%=coe_bean.getEmp_addr()%></TD>
						    </TR>
						    
    <% } else {%>
    						<TR>
								<TD style="height:28px" class=style3>9.&nbsp;성&nbsp;&nbsp;&nbsp;&nbsp;명</TD>
								<TD colspan="2" class=style3>&nbsp;<%=emp_acc_nm%></TD>
								<TD class=style3>10.주민등록번호</TD>
								<TD colspan="3" class=style4>&nbsp;<%=emp_i.get("REC_SSN1")%> - <%=emp_i.get("REC_SSN2")%></TD>
						    </TR>
							<TR>
								<TD style="height:28px" class=style3>11.주&nbsp;&nbsp;&nbsp;&nbsp;소</TD>
							    <TD colspan="6" class=style4>&nbsp;<%=emp_i.get("REC_ADDR")%></TD>
						    </TR>
    <% } %>		    
		
						</table>
					</td>
				</tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD colspan="4" width="110" height="35" align=center class=style4>12.업종구분</TD>
								<TD colspan="6" width="93" align=center style='border-left:solid #000000 2px;border-right:solid #000000 2px;border-top:solid #000000 1px;border-bottom:solid #000000 2px;padding:1.4pt 1.4pt 1.4pt 1.4pt'><b>940911</b></TD>
								<TD colspan="11" width="516" class=style4> ※ 작성방법 참조</TD>
							</TR>
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td align=center>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD height="28" colspan="3" class=style3 align=center>13.지&nbsp;&nbsp;&nbsp;&nbsp; 급</TD>
								<TD colspan="2" class=style3 align=center>14.소득귀속</TD>
								<TD rowspan="2" colspan="2" class=style3 align=center>15.지 급 총 액</TD>
								<TD width="54"rowspan="2" class=style3 align=center>16.세율(%)</TD>
								<TD colspan="3" class=style4 align=center>원&nbsp; 천&nbsp; 징&nbsp; 수&nbsp; 세&nbsp; 액</TD>
				    		</TR>				    		
				    		
				    		
							<TR>
								<TD width="41" height="28" class=style3 align=center>년</TD>
								<TD width="30" class=style3 align=center>월</TD>
								<TD width="30" class=style3 align=center>일</TD>
								<TD width="41" class=style3 align=center>년</TD>
								<TD width="30" class=style3 align=center>월</TD>
								<TD width="100" class=style3 align=center>17.소 득 세</TD>
								<TD width="100" class=style3 align=center>18.지방소득세</TD>
								<TD width="100" class=style4 align=center>19.계</TD>
							</TR>
<%	            
	for(int i = 0 ; i <commi_size ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i); %>
			
						<TR>
								<TD height="23" class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_D")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD colspan="2"  class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseFloat(String.valueOf(commi.get("TOT_PER")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("INC_AMT")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("RES_AMT")))%></TD>
								<TD class=style4  align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%></TD>
							</TR>											

	<% } 
	for(int i = 0 ; i <12 - commi_size ; i++){			%>
				
				<TR>
								<TD height="23" class=style3>&nbsp;</TD>
								<TD class=style3>&nbsp;</TD>
								<TD class=style3>&nbsp;</TD>
								<TD class=style3>&nbsp;</TD>
								<TD class=style3>&nbsp;</TD>
								<TD colspan="2" class=style3 align=right>&nbsp;</TD>
								<TD class=style3 align=right>&nbsp;</TD>
								<TD class=style3 align=right>&nbsp;</TD>
								<TD class=style3 align=right>&nbsp;</TD>
								<TD class=style4 align=right>&nbsp;</TD>
							</TR>									

	<% } %>
					
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD height="22" colspan=2>&nbsp;위의 원천징수세액(수입금액)을 정히 영수(지급)합니다.</TD>
				    		</TR>
							<TR>
								<TD height="22" colspan=2 align=right><%=AddUtil.getDate2(1)%>년&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate2(2)%> 월&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=AddUtil.getDate2(8)%>일
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD height="22" align=right width=300>징수(보고)의무자</td>
								<td align=right>조 성 희 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(서명 또는 인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD height="22" colspan=2 valign=top class=style4 STYLE="font-size:13.0pt;ㅍfont-weight:bold;line-height:160%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;세 무 서 장 &nbsp;&nbsp;귀하</TD>
							</TR>
						</table>
					</td>
			    </tr>
			    <tr>
			        <td height=5></td>
			    </tr>
			    <tr>
			        <td align=center>
			        	<table width="690" border="0" cellspacing="0" cellpadding="0" >
			            	<TR>
								<TD width="678" height="20" align="center" bgcolor="#c1c1c1" >
								작 성 방 법
								</TD>
							</TR>
							<TR>
								<TD width="678" height="70" style="font-size:8pt;" align=left>
								&nbsp;&nbsp;1. 이 서식은 거주자가 사업소득이 발생한 경우에만 작성하며, 비거주자는 별지 제23호서식(5)을 사용하여야 합니다.<br>
								&nbsp;&nbsp;2. 징수의무자란의 (4.)주민(법인)등록번호은 소득자 보관용에는 적지 않습니다.<br>
								&nbsp;&nbsp;3. 세액이 소액부징수에 해당하는 경우에는 (17.) (18.) (19.)란에 세액을 “0”으로 적습니다.<br>
								&nbsp;&nbsp;4. (12.)업종구분란에는 소득자의 업종에 해당하는 아래의 업종구분코드를 적어야 합니다.</td>
							</tr>
							<tr>
								<td align=center>
									<TABLE width="690" border="0" cellspacing="1" cellpadding="0" align=center bgcolor=#3f3f3f>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>업종코드</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>종목</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>업종코드</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>종목</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>업종코드</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>종목</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>업종코드</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>종목</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>업종코드</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>종목</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940100</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>저술가</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940305</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>성악가</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940904</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>직업운동가</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940910</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>다단계판매</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940916</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>행사도우미</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940200</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>화가관련</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940500</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>연예보조</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940905</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>봉사료수취자</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940911</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>기타모집수당</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940917</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>심부름용역</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940301</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>작곡가</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940600</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>자문ㆍ고문</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940906</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>보험설계</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940912</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>간병인</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940918</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>퀵서비스</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940302</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>배우</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940901</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>바둑기사</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940907</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>음료배달</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940913</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>대리운전</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940919</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>물품배달</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940303</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>모델</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940902</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>꽃꽃이교사</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940908</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>방판.외판</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940914</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>캐디</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>851101</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>병의원</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940304</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>가수</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940903</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>학원강사</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940909</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>기타자영</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940915</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>목욕관리사</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>&nbsp;</TD>
											<TD width="70" bgcolor="#ffffcc" class=style23>&nbsp;</TD>
										</TR>
									</TABLE>
								</TD>
							</TR>
							<tr>
								<td height=5></td>
							</tr>
			        	</table>
			        </td>
			    </tr>
			</table>
		</td>
	</tr>
</table>
<% } else {%>

<div id="Layer1" style="position:absolute; left:600px; top:690px; width:54px; height:41px; z-index:1"><img src="http://www.amazoncar.co.kr:8088/acar/main_car_hp/images/stamp.png" width="75" height="75"></div>
<table width="700" border="0" cellspacing="2" cellpadding="0" bgcolor="#000000">
	<tr>
		<td bgcolor="#FFFFFF">
			<table width="700" border="0" cellspacing="0" cellpadding="0">
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0" height=90>
				            <tr>
				                <td valign=top>
				                	<TABLE border="0" cellspacing="0" cellpadding="0" style='border-collapse:collapse;border:none;'>
					                    <TR>
					                        <TD width="43" height="33" class=style3 align=center>귀속<br>연도</TD>
					                        <TD width="63" class=style6 align=right><%= st_year%>년</TD>
					                    </TR>
				                	</TABLE>
				                </td>
				                <td>
				                	<span class=f1>&nbsp;&nbsp;&nbsp;[&nbsp;] 거주자의 사업소득 원천징수영수증</span><br>
				                    <span class=f1>&nbsp;&nbsp;&nbsp;[&nbsp;] 거주자의 사업소득 지급명세서</span><br>
				                    <span class=f2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( <input name="checkbox" type="checkbox" value="checkbox" checked>소득자 보관용&nbsp;&nbsp;<input name="checkbox" type="checkbox" value="checkbox">발행자 보관용 )</span></td>
				                <td align=right>
				                	<TABLE border="0" cellspacing="0" cellpadding="0" style='border-collapse:collapse;border:none;'>
					                    <TR>
					                        <TD colspan="2" width="95" height="25" align="center" class=style7>내ㆍ외국인</TD>
					                        <TD colspan="2" width="105" align="center" class=style2><img src=/acar/images/receipt_img.gif></TD>
					                    </TR>
					                    <TR>
					                        <TD width="36" height="30" align="center" class=style7>거주지국</TD>
					                        <TD width="44" align="center" class=style7>&nbsp;</TD>
					                        <TD width="58" align="center" class=style7>거주지국코드</TD>
					                        <TD width="35" align="center" class=style4>&nbsp;</TD>
					                    </TR>
				                	</TABLE>
				                </td>
				            </tr>
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
				            <TR>
								<TD width="59" rowspan="2" align=center class=style1>징&nbsp; 수<br>의무자</TD>
								<TD width="90" height="34" class=style1>&nbsp;1.사업자<br>&nbsp;&nbsp; 등록번호</TD>
								<TD width="115" class=style1>&nbsp;128-81-47957</TD>
								<TD width="85" class=style1>&nbsp;2.법인명<br>&nbsp;&nbsp; 또는 상호</TD>
								<TD colspan="2" class=style1>&nbsp;(주)아마존카</TD>
								<TD width="50" class=style1>&nbsp;3.성명</TD>
							    <TD width="100" class=style2>&nbsp;조성희</TD>
				            </TR>
							<TR>
								<TD height="28" class=style3>&nbsp;4.주민(법인)<br>&nbsp;&nbsp; 등록번호</TD>
								<TD class=style3>&nbsp;115611-0019610</TD>
								<TD class=style3>&nbsp;5.소재지<br>&nbsp;&nbsp; 또는 주소</TD>
							    <TD colspan="4" class=style4>&nbsp;서울 영등포구 여의도동 17-3 까뮤이앤씨빌딩 8층</TD>
						    </TR>
							<TR>
								<TD rowspan="4" align=center class=style3>소득자</TD>
								<TD height="28" class=style3>&nbsp;6.상&nbsp;&nbsp;&nbsp;&nbsp;호</TD>
								<TD colspan="2" class=style3>&nbsp;</TD>
								<TD width="115" height="33" class=style3>&nbsp;7.사업자등록번호</TD>
								<TD colspan="3" class=style4>&nbsp;</TD>
						    </TR>
							<TR>
								<TD height="28" class=style3>&nbsp;8.사업장<br>&nbsp;&nbsp; 소재지</TD>
							    <TD colspan="6" class=style4>&nbsp;</TD>
						    </TR>
     <% if (  emp_acc_nm.equals("") ) {%>					    
							<TR>
								<TD style="height:28px" class=style3>9.&nbsp;성&nbsp;&nbsp;&nbsp;&nbsp;명</TD>
								<TD colspan="2" class=style3>&nbsp;<%=coe_bean.getEmp_nm()%></TD>
								<TD class=style3>10.주민등록번호</TD>
								<TD colspan="3" class=style4>&nbsp;<%= coe_bean.getEmp_ssn1() %> - <%= coe_bean.getEmp_ssn2() %></TD>
						    </TR>
							<TR>
								<TD style="height:28px" class=style3>11.주&nbsp;&nbsp;&nbsp;&nbsp;소</TD>
							    <TD colspan="6" class=style4>&nbsp;<%=coe_bean.getEmp_addr()%></TD>
						    </TR>
						    
    <% } else {%>
    						<TR>
								<TD style="height:28px" class=style3>9.&nbsp;성&nbsp;&nbsp;&nbsp;&nbsp;명</TD>
								<TD colspan="2" class=style3>&nbsp;<%=emp_acc_nm%></TD>
								<TD class=style3>10.주민등록번호</TD>
								<TD colspan="3" class=style4>&nbsp;<%=emp_i.get("REC_SSN1")%> - <%=emp_i.get("REC_SSN2")%></TD>
						    </TR>
							<TR>
								<TD style="height:28px" class=style3>11.주&nbsp;&nbsp;&nbsp;&nbsp;소</TD>
							    <TD colspan="6" class=style4>&nbsp;<%=emp_i.get("REC_ADDR")%></TD>
						    </TR>
    <% } %>		    
						</table>
					</td>
				</tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD colspan="4" width="110" height="35" align=center class=style4>12.업종구분</TD>
								<TD colspan="6" width="93" align=center style='border-left:solid #000000 2px;border-right:solid #000000 2px;border-top:solid #000000 1px;border-bottom:solid #000000 2px;padding:1.4pt 1.4pt 1.4pt 1.4pt'><b>940911</b></TD>
								<TD colspan="11" width="516" class=style4> ※ 작성방법 참조</TD>
							</TR>
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td align=center>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD height="28" colspan="3" class=style3 align=center>13.지&nbsp;&nbsp;&nbsp;&nbsp; 급</TD>
								<TD colspan="2" class=style3 align=center>14.소득귀속</TD>
								<TD rowspan="2" colspan="2" class=style3 align=center>15.지 급 총 액</TD>
								<TD width="54"rowspan="2" class=style3 align=center>16.세율(%)</TD>
								<TD colspan="3" class=style4 align=center>원&nbsp; 천&nbsp; 징&nbsp; 수&nbsp; 세&nbsp; 액</TD>
				    		</TR>				    		
				    		
				    		
							<TR>
								<TD width="41" height="28" class=style3 align=center>년</TD>
								<TD width="30" class=style3 align=center>월</TD>
								<TD width="30" class=style3 align=center>일</TD>
								<TD width="41" class=style3 align=center>년</TD>
								<TD width="30" class=style3 align=center>월</TD>
								<TD width="100" class=style3 align=center>17.소 득 세</TD>
								<TD width="100" class=style3 align=center>18.지방소득세</TD>
								<TD width="100" class=style4 align=center>19.계</TD>
							</TR>
				
	<% 	for(int i = 0 ; i < 12  ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);  %>													
						
				<TR>
								<TD height="23" class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_D")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD colspan="2"  class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseFloat(String.valueOf(commi.get("TOT_PER")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("INC_AMT")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("RES_AMT")))%></TD>
								<TD class=style4  align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%></TD>
							</TR>	
										

	<% } %>
						
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD height="22" colspan=2>&nbsp;위의 원천징수세액(수입금액)을 정히 영수(지급)합니다.</TD>
				    		</TR>
							<TR>
								<TD height="22" colspan=2 align=right><%=AddUtil.getDate2(1)%>년&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate2(2)%> 월&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=AddUtil.getDate2(8)%>일
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD height="22" align=right width=300>징수(보고)의무자</td>
								<td align=right>조 성 희 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(서명 또는 인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD height="22" colspan=2 valign=top class=style4 STYLE="font-size:13.0pt;ㅍfont-weight:bold;line-height:160%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;세 무 서 장 &nbsp;&nbsp;귀하</TD>
							</TR>
						</table>
					</td>
			    </tr>
			    <tr>
			        <td height=5></td>
			    </tr>
			    <tr>
			        <td align=center>
			        	<table width="690" border="0" cellspacing="0" cellpadding="0" >
			            	<TR>
								<TD width="678" height="20" align="center" bgcolor="#c1c1c1" >
								작 성 방 법
								</TD>
							</TR>
							<TR>
								<TD width="678" height="70" style="font-size:8pt;" align=left>
								&nbsp;&nbsp;1. 이 서식은 거주자가 사업소득이 발생한 경우에만 작성하며, 비거주자는 별지 제23호서식(5)을 사용하여야 합니다.<br>
								&nbsp;&nbsp;2. 징수의무자란의 (4.)주민(법인)등록번호은 소득자 보관용에는 적지 않습니다.<br>
								&nbsp;&nbsp;3. 세액이 소액부징수에 해당하는 경우에는 (17.) (18.) (19.)란에 세액을 “0”으로 적습니다.<br>
								&nbsp;&nbsp;4. (12.)업종구분란에는 소득자의 업종에 해당하는 아래의 업종구분코드를 적어야 합니다.</td>
							</tr>
							<tr>
								<td align=center>
									<TABLE width="690" border="0" cellspacing="1" cellpadding="0" align=center bgcolor=#3f3f3f>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>업종코드</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>종목</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>업종코드</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>종목</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>업종코드</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>종목</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>업종코드</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>종목</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>업종코드</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>종목</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940100</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>저술가</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940305</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>성악가</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940904</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>직업운동가</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940910</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>다단계판매</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940916</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>행사도우미</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940200</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>화가관련</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940500</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>연예보조</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940905</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>봉사료수취자</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940911</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>기타모집수당</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940917</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>심부름용역</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940301</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>작곡가</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940600</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>자문ㆍ고문</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940906</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>보험설계</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940912</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>간병인</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940918</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>퀵서비스</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940302</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>배우</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940901</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>바둑기사</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940907</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>음료배달</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940913</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>대리운전</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940919</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>물품배달</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940303</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>모델</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940902</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>꽃꽃이교사</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940908</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>방판.외판</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940914</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>캐디</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>851101</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>병의원</TD>
										</TR>
										<TR>
											<TD width="66" height="18" bgcolor="#ffffcc" class=style8>940304</TD>
											<TD width="63" bgcolor="#ffffcc" class=style8>가수</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940903</TD>
											<TD width="70" bgcolor="#ffffcc" class=style8>학원강사</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940909</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>기타자영</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>940915</TD>
											<TD width="78" bgcolor="#ffffcc" class=style8>목욕관리사</TD>
											<TD width="59" bgcolor="#ffffcc" class=style8>&nbsp;</TD>
											<TD width="70" bgcolor="#ffffcc" class=style23>&nbsp;</TD>
										</TR>
									</TABLE>
								</TD>
							</TR>
							<tr>
								<td height=5></td>
							</tr>
			        	</table>
			        </td>
			    </tr>
			</table>
		</td>
	</tr>
</table>
  <%    for(int p = 0 ; p <page_size1 ; p++) {  
             int      k=p+1;     
               %>		
             			
<p style='page-break-before:always'><br style="height:0; line-height:0"></P>

<table width="700" border="0" cellspacing="2" cellpadding="0" bgcolor="#000000">
	<tr>
		<td bgcolor="#FFFFFF">

			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD height="28" colspan="3" class=style3 align=center>13.지&nbsp;&nbsp;&nbsp;&nbsp; 급</TD>
								<TD colspan="2" class=style3 align=center>14.소득귀속</TD>
								<TD rowspan="2" colspan="2" class=style3 align=center>15.지 급 총 액</TD>
								<TD width="54"rowspan="2" class=style3 align=center>16.세율(%)</TD>
								<TD colspan="3" class=style4 align=center>원&nbsp; 천&nbsp; 징&nbsp; 수&nbsp; 세&nbsp; 액</TD>
				    		</TR>				    		
				    		
				    		
							<TR>
								<TD width="41" height="28" class=style3 align=center>년</TD>
								<TD width="30" class=style3 align=center>월</TD>
								<TD width="30" class=style3 align=center>일</TD>
								<TD width="41" class=style3 align=center>년</TD>
								<TD width="30" class=style3 align=center>월</TD>
								<TD width="100" class=style3 align=center>17.소 득 세</TD>
								<TD width="100" class=style3 align=center>18.지방소득세</TD>
								<TD width="100" class=style4 align=center>19.계</TD>
							</TR>				
		 <% 	for(int i = 12+(p*40) ; i <12+(k*40)  ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);  						
				%>													
						
						        <TR>
								<TD height="23" class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_D")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD colspan="2"  class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseFloat(String.valueOf(commi.get("TOT_PER")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("INC_AMT")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("RES_AMT")))%></TD>
								<TD class=style4  align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%></TD>
							</TR>											

			<% }  %>
		
		    </table>
	</td>
	</tr>
</table>			    
    <% }   %>
<!-- 마지막 페이지 출력 -->  
  <p style='page-break-before:always'><br style="height:0; line-height:0"></P>

<table width="700" border="0" cellspacing="2" cellpadding="0" bgcolor="#000000">
	<tr>
		<td bgcolor="#FFFFFF">

			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD height="28" colspan="3" class=style3 align=center>13.지&nbsp;&nbsp;&nbsp;&nbsp; 급</TD>
								<TD colspan="2" class=style3 align=center>14.소득귀속</TD>
								<TD rowspan="2" colspan="2" class=style3 align=center>15.지 급 총 액</TD>
								<TD width="54"rowspan="2" class=style3 align=center>16.세율(%)</TD>
								<TD colspan="3" class=style4 align=center>원&nbsp; 천&nbsp; 징&nbsp; 수&nbsp; 세&nbsp; 액</TD>
				    		</TR>				    		
				    		
				    		
							<TR>
								<TD width="41" height="28" class=style3 align=center>년</TD>
								<TD width="30" class=style3 align=center>월</TD>
								<TD width="30" class=style3 align=center>일</TD>
								<TD width="41" class=style3 align=center>년</TD>
								<TD width="30" class=style3 align=center>월</TD>
								<TD width="100" class=style3 align=center>17.소 득 세</TD>
								<TD width="100" class=style3 align=center>18.지방소득세</TD>
								<TD width="100" class=style4 align=center>19.계</TD>
							</TR>				
		  <% for(int i = 12+(page_size1*40) ; i <12+(page_size1*40) +list_size1  ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);  						
				%>													
						
						        <TR>
								<TD height="23" class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_D")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style3>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD colspan="2"  class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseFloat(String.valueOf(commi.get("TOT_PER")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("INC_AMT")))%></TD>
								<TD class=style3 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("RES_AMT")))%></TD>
								<TD class=style4  align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%></TD>
							</TR>	
										

			<% } 
			for(int i = 0 ; i <40 - list_size1 ; i++){			%>			
						<TR>
										<TD height="23" class=style3>&nbsp;</TD>
										<TD class=style3>&nbsp;</TD>
										<TD class=style3>&nbsp;</TD>
										<TD class=style3>&nbsp;</TD>
										<TD class=style3>&nbsp;</TD>
										<TD colspan="2" class=style3 align=right>&nbsp;</TD>
										<TD class=style3 align=right>&nbsp;</TD>
										<TD class=style3 align=right>&nbsp;</TD>
										<TD class=style3 align=right>&nbsp;</TD>
										<TD class=style4 align=right>&nbsp;</TD>
						</TR>						

		    <% }     %>
		    </table>
	</td>
	</tr>
</table>			     

<% }   %>
	
</body>
</html>
