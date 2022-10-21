<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String gubun = request.getParameter("gubun")==null?"4":request.getParameter("gubun");	
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");	
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");	
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String g_fm = "1";
	String fn_id= "0";
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	String [] rcst = cdb.getRentCondSta_20071025(dt,ref_dt1,ref_dt2,gubun2, gubun3, gubun4);
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	int cnt = 2+3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
function CarRegList(rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, rpt_no, firm_nm, client_nm, imm_amt)
{
	var theForm = document.CarRegDispForm;
	theForm.rent_mng_id.value = rent_mng_id;
	theForm.rent_l_cd.value = rent_l_cd;
	theForm.car_mng_id.value = car_mng_id;
	theForm.cmd.value = reg_gubun;
	theForm.rpt_no.value = rpt_no;
	theForm.firm_nm.value = firm_nm;
	theForm.client_nm.value = client_nm;
	theForm.imm_amt.value = imm_amt;
	
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		theForm.action = "./register_frame.jsp";
<%	}else{%>
		if(reg_gubun=="id"){	alert("미등록 상태입니다.");	return;	}
		theForm.action = "./register_frame.jsp";
<%	}%>
	theForm.target = "d_content"
	theForm.submit();
}

function view_cont(m_id, l_cd)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.mode.value = '2'; /*조회*/
		fm.g_fm.value = '1';
		fm.action = '/fms2/lc_rent/lc_c_frame.jsp';
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form name='form1' method='post' target='d_content' action='/acar/car_rent/con_reg_frame.jsp'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='g_fm' value='1'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd'  value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>	
 <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td><iframe src="./rent_cond_sc_in.jsp?auth_rw=<%=auth_rw%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun2=<%= gubun2 %>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&sort=<%=sort%>" name="RegCondList" width="100%" height="<%=height - 80 %>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>		
    </tr>  
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td>
	        <table border=0 cellspacing=0 cellpadding=0 width=100%>
                <tr> 
                    <td width="40%">
			            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td class="line">
            				        <table border=0 cellspacing=1 width=100%>
            				            <tr>
			                                <td colspan=3 class=line2 style='height:1'></td>
			                            </tr>
                                        <tr> 
                                            <td colspan="3" class=title>렌트</td>
                                        </tr>
                                        <tr> 
                                            <td class=title>일반식</td>
                                            <td class=title>맞춤식</td>
                                            <td class=title>기본식</td>
                                        </tr>
                                        <tr> 
                                            <td align="right"><%=rcst[0]%> 건 </td>
                                            <td align="right"><%=rcst[1]%> 건 </td>
                                            <td align="right"><%=rcst[2]%> 건 </td>
                                        </tr>
                                    </table>
            				    </td>
                                <td class="line">
            				        <table border=0 cellspacing=1 width=100%>
            				            <tr>
			                                <td colspan=3 class=line2 style='height:1'></td>
			                            </tr>
                                        <tr> 
                                            <td colspan="3" class=title>리스</td>
                                        </tr>
                                        <tr> 
                                            <td class=title>일반식</td>
                                            <td class=title>맞춤식</td>
                                            <td class=title>기본식</td>
                                        </tr>
                                        <tr> 
                                            <td align="right"><%=rcst[3]%> 건 </td>
                                            <td align="right"><%=rcst[4]%> 건 </td>
                                            <td align="right"><%=rcst[5]%> 건 </td>
                                        </tr>
                                    </table>
            				    </td>
                            </tr>
                        </table>
                    </td>
                    <td width="30%">
            		    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td class="line">
            				        <table border=0 cellspacing=1 width=100%>
            				            <tr>
			                                <td colspan=5 class=line2 style='height:1'></td>
			                            </tr>
                                        <tr> 
                                            <td colspan="5" class=title>대여개월</td>
                                        </tr>
                                        <tr> 
                                            <td class=title>48개월</td>
                                            <td class=title>36개월</td>
                                            <td class=title>24개월</td>
                                            <td class=title>12개월</td>
                                            <td class=title>기타</td>
                                        </tr>
                                        <tr> 
                                            <td align="right"><%=rcst[6]%> 건 </td>
                                            <td align="right"><%=rcst[7]%> 건 </td>
                                            <td align="right"><%=rcst[8]%> 건 </td>
                                            <td align="right"><%=rcst[9]%> 건 </td>
                                            <td align="right"><%=rcst[10]%> 건 </td>
                                        </tr>
                                    </table>
            			        </td>
                            </tr>
                        </table>
                    </td>
                    <td width="30%">
            		    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td class="line">
            				        <table border=0 cellspacing=1 width=100%>
            				            <tr>
			                                <td colspan=3 class=line2 style='height:1'></td>
			                            </tr>
                                        <tr> 
                                            <td colspan="3" class=title>대여금액</td>
                                        </tr>
                                        <tr> 
                                            <td class=title>공급가</td>
                                            <td class=title>부가세</td>
                                            <td class=title>합계</td>
                                        </tr>
                                        <tr> 
                                            <td align="right"><%=Util.parseDecimal(rcst[11])%> 원</td>
                                            <td align="right"><%=Util.parseDecimal(rcst[12])%> 원</td>
                                            <td align="right"><%=Util.parseDecimal(rcst[13])%> 원</td>
                                        </tr>
                                    </table>
            				    </td>
                            </tr>
                        </table>
            	    </td>
                </tr>
            </table>
	    </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td>
	        <table border=0 cellspacing=0 cellpadding=0 width=100%>
                <tr> 
                    <td width="50%" valign=top>
			            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td class="line">
            				        <table border=0 cellspacing=1 width=100%>
            				            <tr>
			                                <td colspan=7 class=line2 style='height:1'></td>
			                            </tr>
                    				    <tr>
                    			            <td width="15%" class=title style='height:45'>영업사원</td>
                    			            <td width="15%" class=title>에이젼트</td>
                    			            <td width="14%" class=title>기존업체<br>소개</td>
                    			            <td width="14%" class=title>기존업체</td>
                    			            <td width="14%" class=title>인터넷</td>
                    			            <td width="14%" class=title>catalog<br>발송</td>
                    			            <td width="14%" class=title>전화상담</td>
                    			        </tr>
                    			        <tr>
                    			            <td align="center"><%=rcst[15]%> 건 </td>
                    			            <td align="center"><%=rcst[20]%> 건 </td>
                    			            <td align="center"><%=rcst[16]%> 건 </td>
                    			            <td align="center"><%=rcst[19]%> 건 </td>
                    			            <td align="center"><%=rcst[14]%> 건 </td>
                    			            <td align="center"><%=rcst[17]%> 건 </td>
                    			            <td align="center"><%=rcst[18]%> 건 </td>
                    			        </tr>
            			            </table>
            				    </td>
                            </tr>
                        </table>
		            </td>
                    <td width="50%">
		                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td class="line">
				                    <table border=0 cellspacing=1 width=100%>
				                        <tr>
			                                <td colspan=6 class=line2 style='height:1'></td>
			                            </tr>
			                            <tr>
                    			            <td width="15%" rowspan="2" class=title>연장</td>
                    			            <td colspan="3" class=title>재리스</td>
                    			            <td colspan="3" class=title>신차</td>		  
		                                </tr>
			                            <tr>
                        			        <td width="15%" class=title>증차</td>
                        		            <td width="14%" class=title>대차</td>
                        			        <td width="14%" class=title>신규</td>
                        		            <td width="14%" class=title>증차</td>
                        			        <td width="14%" class=title>대차</td>
                        			        <td width="14%" class=title>신규</td>
			                            </tr>
			                            <tr>
                    			            <td align="center"><%=rcst[21]%> 건 </td>					  
                    			            <td align="center"><%=rcst[27]%> 건 </td>
                    			            <td align="center"><%=rcst[26]%> 건 </td>					  
                    			            <td align="center"><%=rcst[25]%> 건 </td>
                    			            <td align="center"><%=rcst[24]%> 건 </td>
                    			            <td align="center"><%=rcst[23]%> 건 </td>
                    			            <td align="center"><%=rcst[22]%> 건 </td>
			                            </tr>
			                        </table>
				                </td>
                            </tr>
                        </table>
	                </td>
                </tr>
            </table>
	    </td>
    </tr> 
</table>
</body>
</html>