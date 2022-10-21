<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.commi_mng.*, acar.car_office.*"%>
<jsp:useBean id="acm_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>
<%@ include file="/agent/cookies.jsp" %>
<%@ include file="/agent/access_log.jsp" %>

<%
	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
		
	
	String st_year = request.getParameter("st_year")==null?Integer.toString(AddUtil.getDate2(1)):request.getParameter("st_year");//귀속연도
	String st_dt = st_year  + "0101";
	String end_dt = st_year + "1231";	
	
	int year = AddUtil.parseInt(st_year);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	
	String emp_id  = "";
	
	emp_id = c_db.getNameById(ck_acar_id, "USER_SA");
	String emp_acc_nm = request.getParameter("emp_acc_nm")==null?"":request.getParameter("emp_acc_nm");//실수령인

	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp_id);
	
	//실수령인
	Vector emp_acc = acm_db.getEmpAccList(emp_id );
	int  emp_acc_size = emp_acc.size();
	
	Hashtable emp_i = acm_db.getEmpAccNm(emp_id, emp_acc_nm);	
			
	Vector commis = acm_db.getCommiReceiptList("", "9", "4", "2", "", st_dt, end_dt, "13", emp_acc_nm, "9", "0" , ck_acar_id, emp_id  );
	int commi_size = commis.size();
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 11; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height);//현황 라인수만큼 제한 아이프레임 사이즈
	
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>무제 문서</title>

<STYLE>
<!--
* {line-height:130%; font-size:10.0pt; font-family:돋움체;}


.style11 {border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style12 {border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style13 {border-right:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style14 {border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style15 {border-right:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style16 {border-left:solid #000000 1px;border-right:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style17 {border-left:solid #000000 1px;border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt; height:30px;}
.style18 {font-size:8.0pt; text-align:center;  background-color:#ffffcc; height:20px;}


.f1{font-size:13pt; font-weight:bold; line-height:150%;}
.f2{font-size:10.5pt; line-height:150%;}
-->
</STYLE>
<script language="JavaScript" type="text/JavaScript">

<!--
function Search()
{
		var fm = document.form1;
	
		fm.target =  "_self";
		fm.action =  "commi_receipt.jsp";
		fm.submit();
}

function Print()
{
		
		var fm = document.form1;
	
		fm.action = "commi_receipt_print.jsp";
		fm.target = "i_no";
	//	fm.target = "_blank";	
		fm.submit();		
		
}


//-->
</script>

</head>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form  name="form1"  method="POST">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=5>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>Agent> 수당관리 > <span class=style5>원천징수영수증관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
     <tr> 
      <td> 
        <table width="100%" border="0" cellpadding="0" cellspacing="1">
          <tr> 
          	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
			 
		            <select name="st_year" >
						<%for(int i=2012; i<=year; i++){%>
						<option value="<%=i%>" <%if(year == i){%>selected<%}%>><%=i%>년</option>
						<%}%>
					</select> 					
		</td>
		
		   <td>&nbsp;&nbsp;&nbsp;
			 
			     <select name='emp_acc_nm'>
                <option value="">선택</option>
                <%	if(emp_acc_size > 0){
						for(int i = 0 ; i < emp_acc_size ; i++){
							Hashtable emp_nm = (Hashtable)emp_acc.elementAt(i); %>
		                <option value='<%=emp_nm.get("EMP_ACC_NM")%>' <%if ( emp_acc_nm.equals(String.valueOf( emp_nm.get("EMP_ACC_NM")) )  ){%>selected<%}%>><%=emp_nm.get("EMP_ACC_NM")%></option>
		                <%		}
							}%>
		              </select></td>              
              			
		</td>
	          
             <td align=right>  
            <a href='javascript:Search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;
              <a href='javascript:Print()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;
             
           </td>
           </tr>
        </table>
      </td>
      <tr><td class=h></td></tr>


<div id="Layer1" style="position:absolute; left:600px; top:620px; width:54px; height:41px; z-index:1"></div>
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
					                        <TD width="43" height="33" class=style13 align=center>귀속<br>연도</TD>
					                        <TD width="63" class=style16 align=right><%=  st_year%>년</TD>
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
					                        <TD colspan="2" width="95" height="25" align="center" class=style17>내ㆍ외국인</TD>
					                        <TD colspan="2" width="105" align="center" class=style12><img src=/agent/images/receipt_img.gif></TD>
					                    </TR>
					                    <TR>
					                        <TD width="36" height="30" align="center" class=style17>거주지국</TD>
					                        <TD width="44" align="center" class=style17>&nbsp;</TD>
					                        <TD width="58" align="center" class=style17>거주지국코드</TD>
					                        <TD width="35" align="center" class=style14>&nbsp;</TD>
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
								<TD width="59" rowspan="2" align=center class=style11>징&nbsp; 수<br>의무자</TD>
								<TD width="90" height="34" class=style11>1.사업자<br>&nbsp;&nbsp;등록번호</TD>
								<TD width="115" class=style11>&nbsp;128-81-47957</TD>
								<TD width="85" class=style11>2.법인명<br>&nbsp;&nbsp;또는 상호</TD>
								<TD colspan="2" class=style11>&nbsp;(주)아마존카</TD>
								<TD width="50" class=style11>3.성명</TD>
							    <TD width="110" class=style12>&nbsp;조성희</TD>
				            </TR>
							<TR>
								<TD height="28" class=style13>4.주민(법인)<br>&nbsp;&nbsp;등록번호</TD>
								<TD class=style13>&nbsp;115611-0019610</TD>
								<TD class=style13>5.소재지<br>&nbsp;&nbsp;또는 주소</TD>
							    <TD colspan="4" class=style14>&nbsp;서울 영등포구 여의도동 17-3 까뮤이앤씨빌딩 8층</TD>
						    </TR>
							<TR>
								<TD rowspan="4" align=center class=style13>소득자</TD>
								<TD style="height:28px" class=style13>6.상&nbsp;&nbsp;&nbsp;&nbsp;호</TD>
								<TD colspan="2" class=style13>&nbsp;</TD>
								<TD width="105" height="33" class=style13>7.사업자등록번호</TD>
								<TD colspan="3" class=style14>&nbsp;</TD>
						    </TR>
							<TR>
								<TD height="28" class=style13>8.사업장<br>&nbsp;&nbsp;소재지</TD>
							    <TD colspan="6" class=style14>&nbsp;</TD>
						    </TR>
	
	<% if (  emp_acc_nm.equals("") ) {%>					    
							<TR>
								<TD style="height:28px" class=style13>9.&nbsp;성&nbsp;&nbsp;&nbsp;&nbsp;명</TD>
								<TD colspan="2" class=style13>&nbsp;<%=coe_bean.getEmp_nm()%></TD>
								<TD class=style13>10.주민등록번호</TD>
								<TD colspan="3" class=style14>&nbsp;<%= coe_bean.getEmp_ssn1() %> - <%= coe_bean.getEmp_ssn2() %></TD>
						    </TR>
							<TR>
								<TD style="height:28px" class=style13>11.주&nbsp;&nbsp;&nbsp;&nbsp;소</TD>
							    <TD colspan="6" class=style14>&nbsp;<%=coe_bean.getEmp_addr()%></TD>
						    </TR>
						    
    <% } else {%>
    						<TR>
								<TD style="height:28px" class=style13>9.&nbsp;성&nbsp;&nbsp;&nbsp;&nbsp;명</TD>
								<TD colspan="2" class=style13>&nbsp;<%=emp_acc_nm%></TD>
								<TD class=style13>10.주민등록번호</TD>
								<TD colspan="3" class=style14>&nbsp;<%=emp_i.get("REC_SSN1")%> - <%=emp_i.get("REC_SSN2")%></TD>
						    </TR>
							<TR>
								<TD style="height:28px" class=style13>11.주&nbsp;&nbsp;&nbsp;&nbsp;소</TD>
							    <TD colspan="6" class=style14>&nbsp;<%=emp_i.get("REC_ADDR")%></TD>
						    </TR>
    <% } %>			
    					    
					
						</table>
					</td>
				</tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD colspan="4" width="110" style="height:35px" align=center class=style14>12.업종구분</TD>
								<TD colspan="6" width="93" align=center style='border-left:solid #000000 2px;border-right:solid #000000 2px;border-top:solid #000000 1px;border-bottom:solid #000000 2px;padding:1.4pt 1.4pt 1.4pt 1.4pt'><b>940911</b></TD>
								<TD colspan="11" width="516" class=style14> ※ 작성방법 참조</TD>
							</TR>
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td align=center>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD style="height:28px"  colspan="3" class=style13 align=center>13.지&nbsp;&nbsp;&nbsp;&nbsp; 급</TD>
								<TD colspan="2" class=style13>14.소득귀속</TD>
								<TD rowspan="2" colspan="2" class=style13>15.지 급 총 액</TD>
								<TD width="54"rowspan="2" class=style13>16.세율(%)</TD>
								<TD colspan="3" class=style14>원&nbsp; 천&nbsp; 징&nbsp; 수&nbsp; 세&nbsp; 액</TD>
				    		</TR>				    		
				    		
				    		
							<TR>
								<TD width="41" style="height:28px" class=style13>년</TD>
								<TD width="30" class=style13>&nbsp;월</TD>
								<TD width="30" class=style13>일</TD>
								<TD width="41" class=style13>년</TD>
								<TD width="30" class=style13>월</TD>
								<TD width="100" class=style13>17.소 득 세</TD>
								<TD width="100" class=style13>18.지방소득세</TD>
								<TD width="100" class=style14>19.계</TD>
							</TR>
<%	if(commi_size <1){%>	
<%		for(int i = 0 ; i < 12 ; i++){ %>								
							<TR>
								<TD style="height:23px" class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD colspan="2" class=style13 align=right>&nbsp;</TD>
								<TD class=style13 align=right>&nbsp;</TD>
								<TD class=style13 align=right>&nbsp;</TD>
								<TD class=style13 align=right>&nbsp;</TD>
								<TD class=style14 align=right>&nbsp;</TD>
							</TR>
<%	} %>						

<% } else { %>
<%		for(int i = 0 ; i < commi_size ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);
				
				total_amt = total_amt  + Long.parseLong(String.valueOf(commi.get("COMMI")));
        				total_amt2 = total_amt2  + Long.parseLong(String.valueOf(commi.get("INC_AMT")));
        				total_amt3 = total_amt3  + Long.parseLong(String.valueOf(commi.get("RES_AMT")));
        				total_amt4 = total_amt4  + Long.parseLong(String.valueOf(commi.get("COMMI_FEE")));  %>

							<TR>
								<TD style="height:23px" class=style13>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style13>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD class=style13>&nbsp;<%=commi.get("SUP_DT_D")%></TD>
								<TD class=style13>&nbsp;<%=commi.get("SUP_DT_Y")%></TD>
								<TD class=style13>&nbsp;<%=commi.get("SUP_DT_M")%></TD>
								<TD colspan="2"  class=style13 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></TD>
								<TD class=style13 align=right>&nbsp;<%=Util.parseFloat(String.valueOf(commi.get("TOT_PER")))%></TD>
								<TD class=style13 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("INC_AMT")))%></TD>
								<TD class=style13 align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("RES_AMT")))%></TD>
								<TD class=style14  align=right>&nbsp;<%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%></TD>
							</TR>

	<% } %>
<% } %>					
						   	<TR>
								<TD style="height:23px" class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD class=style13>&nbsp;</TD>
								<TD colspan="2"  class=style13 align=right>&nbsp;<%=Util.parseDecimal(total_amt)%></TD>
								<TD class=style13 align=right>&nbsp;</TD>
								<TD class=style13 align=right>&nbsp;<%=Util.parseDecimal(total_amt2)%></TD>
								<TD class=style13 align=right>&nbsp;<%=Util.parseDecimal(total_amt3)%></TD>
								<TD class=style14  align=right>&nbsp;<%=Util.parseDecimal(total_amt4)%></TD>
							</TR>		
							
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td>
			        	<table width="700" border="0" cellspacing="0" cellpadding="0">
			            	<TR>
								<TD style="height:22px" colspan=2 style="border-top:1px solid #000000;">&nbsp;위의 원천징수세액(수입금액)을 정히 영수(지급)합니다.</TD>
				    		</TR>
							<TR>
								<TD style="height:22px" colspan=2 align=right><%=AddUtil.getDate2(1)%>년&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=AddUtil.getDate2(2)%> 월&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=AddUtil.getDate2(8)%>일
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD style="height:22px" align=right width=300>징수(보고)의무자</td>
								<td align=right>조 성 희 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(서명 또는 인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD style="height:22px" colspan=2 valign=top class=style14 STYLE="font-size:13.0pt;ㅍfont-weight:bold;line-height:160%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;세 무 서 장 &nbsp;&nbsp;귀하</TD>
							</TR>
						</table>
					</td>
			    </tr>
			    <tr>
			        <td style="height:5px;"></td>
			    </tr>
			    <tr>
			        <td align=center>
			        	<table width="690" border="0" cellspacing="0" cellpadding="0" >
			            	<TR>
								<TD colspan="21" width="678" style="height:25px;background-color:#c1c1c1;" align="center">
								작 성 방 법
								</TD>
							</TR>
							<TR>
								<TD colspan="21" width="678" style="height:80px" style="font-size:8pt;" align=left>
								&nbsp;&nbsp;1. 이 서식은 거주자가 사업소득이 발생한 경우에만 작성하며, 비거주자는 별지 제23호서식(5)을 사용하여야 합니다.<br>
								&nbsp;&nbsp;2. 징수의무자란의 ④주민(법인)등록번호은 소득자 보관용에는 적지 않습니다.<br>
								&nbsp;&nbsp;3. 세액이 소액부징수에 해당하는 경우에는 (17.) (18.) (19.)란에 세액을 “0”으로 적습니다.<br>
								&nbsp;&nbsp;4. (12.)업종구분란에는 소득자의 업종에 해당하는 아래의 업종구분코드를 적어야 합니다.</td>
							</tr>
							<tr>
								<td align=center>
									<TABLE width="690" border="0" cellspacing="1" cellpadding="0" align=center bgcolor=#3f3f3f>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>업종코드</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>종목</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>업종코드</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>종목</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>업종코드</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>종목</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>업종코드</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>종목</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>업종코드</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>종목</TD>
										</TR>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>940100</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>저술가</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940305</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>성악가</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940904</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>직업운동가</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940910</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>다단계판매</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940916</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>행사도우미</TD>
										</TR>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>940200</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>화가관련</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940500</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>연예보조</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940905</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>봉사료수취자</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940911</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>기타모집수당</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940917</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>심부름용역</TD>
										</TR>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>940301</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>작곡가</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940600</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>자문ㆍ고문</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940906</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>보험설계</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940912</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>간병인</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940918</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>퀵서비스</TD>
										</TR>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>940302</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>배우</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940901</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>바둑기사</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940907</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>음료배달</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940913</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>대리운전</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940919</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>물품배달</TD>
										</TR>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>940303</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>모델</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940902</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>꽃꽃이교사</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940908</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>방판.외판</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940914</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>캐디</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>851101</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>병의원</TD>
										</TR>
										<TR>
											<TD width="66" height="20" bgcolor="#ffffcc" class=style18>940304</TD>
											<TD width="63" bgcolor="#ffffcc" class=style18>가수</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940903</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>학원강사</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940909</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>기타자영</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>940915</TD>
											<TD width="78" bgcolor="#ffffcc" class=style18>목욕관리사</TD>
											<TD width="59" bgcolor="#ffffcc" class=style18>&nbsp;</TD>
											<TD width="70" bgcolor="#ffffcc" class=style18>&nbsp;</TD>
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
  </form>
</table>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>
</body>
</html>
