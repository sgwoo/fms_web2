<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>
 	
<%
	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");

	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
		
	ClientBean client = al_db.getNewClient(client_id);
	
%>	
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//목록가기	
	function go_to_list()
	{
		var fm = document.form1;
		var s_kd = fm.s_kd.value;
		var t_wd = fm.t_wd.value;
		var asc = fm.asc.value;
		location='/agent/client/client_s_frame.jsp?s_kd='+s_kd+'&t_wd='+t_wd+'&asc='+asc;
	}
	
	//사업장등록증이력
	function cl_enp_h(client_id, firm_nm)
	{
		var fm = document.form1;
		window.open("about:blank", "CLIENT_ENP", "left=50, top=50, width=1000, height=600, resizable=yes, scrollbars=yes, status=yes");				
		fm.action = "/agent/client/client_enp_p.jsp";
		fm.target = "CLIENT_ENP";
		fm.submit();
	}	

	//지점/현장관리
	function cl_site(client_id, firm_nm)
	{
		window.open('/agent/client/client_site_s_p.jsp?client_id='+client_id+'&firm_nm='+firm_nm, "CLIENT_SITE", "left=100, top=100, width=650, height=500, resizable=yes, scrollbars=yes, status=yes");
	}
		
	//재무제표
	function cl_fin(client_id, firm_nm)
	{
		window.open('/agent/client/client_fin_s_p.jsp?client_id='+client_id+'&firm_nm='+firm_nm, "CLIENT_SITE", "left=100, top=100, width=750, height=500, resizable=yes, scrollbars=yes, status=yes");
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>


<body>
<form name='form1' method='post'>

<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>고객정보</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;
	    <font color="#999999">
        <img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(client.getReg_id(), "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> :
            <%=AddUtil.ChangeDate2(client.getReg_dt())%>
    		&nbsp;&nbsp;
            <img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(client.getUpdate_id(), "USER")%>&nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> : 
            <%=AddUtil.ChangeDate2(client.getUpdate_dt())%>
            </font> 
        </td>
        <td align='right'>
    	    <%	if(from_page.equals("")){%>
            &nbsp;&nbsp;<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a> 
            <%	}%>		
	    </td>
    </tr> 
    <tr>
        <td class=line2 colspan=2></td>
    </tr>         
    <tr> 
        <td colspan="2" class='line'>
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='13%'>고객구분</td>
                    <td>&nbsp; 
                      <%if(client.getClient_st().equals("1")) 		out.println("법인");
                      	else if(client.getClient_st().equals("2"))  out.println("개인");
                      	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
                      	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
                      	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");
        				else if(client.getClient_st().equals("6")) 	out.println("경매장");%>
						&nbsp; 
						<%=client_id%>
                    </td>
                </tr>
            </table>
        </td>
	</tr>   
	<tr>
	    <td class=h></td>
	</tr> 
    <tr id=tr_acct1 style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">  
        <td colspan="2">
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    		    <tr>	
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>법인</span></td>
    		    </tr>
    		    <tr>
    		        <td class=line2></td>
    		    </tr>
    		    <tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td colspan="2" class='title'>법인규모</td>
            		            <td>&nbsp;
                			        <%if(client.getFirm_st().equals("1")) 		out.println("대기업");
                	               	else if(client.getFirm_st().equals("2"))	out.println("중기업");
                					else if(client.getFirm_st().equals("3"))	out.println("소기업");
                					else if(client.getFirm_st().equals("4"))	out.println("크레탑미등재");%>
                	               	&nbsp;<%if(client.getEnp_yn().equals("Y")) 	out.println("대기업");%> 
                				    &nbsp;<%= client.getEnp_nm()%> &nbsp;<%if(client.getEnp_yn().equals("Y")) 	out.println("계열사");%> 
            				    </td>            			
            		            <td class='title'>법인형태</td>
            		            <td>&nbsp;
            		             <%if(client.getFirm_type().equals("1")) 		out.println("유가증권시장");
            	              	 else if(client.getFirm_type().equals("2")) 	out.println("코스닥상장");
            	              	 else if(client.getFirm_type().equals("3"))   	out.println("외감법인");
            	              	 else if(client.getFirm_type().equals("4"))   	out.println("벤처기업");
            	              	 else if(client.getFirm_type().equals("5"))   	out.println("일반법인");
            	              	 else if(client.getFirm_type().equals("6"))   	out.println("국가");
            	              	 else if(client.getFirm_type().equals("7"))   	out.println("지방자치단체");
            	              	 else if(client.getFirm_type().equals("8"))   	out.println("정부투자기관");
            	              	 else if(client.getFirm_type().equals("9"))		out.println("정부출연연구기관");
								 else if(client.getFirm_type().equals("10"))	out.println("비영리법인");
								 else if(client.getFirm_type().equals("11"))	out.println("면세법인");
								 %>
            	                </td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>설립일자</td>
            		            <td>&nbsp;
            		                <%= client.getFound_year()%></td>
            		            <td class='title'>개업일자</td>
            		            <td>&nbsp;
            		                <%= client.getOpen_year()%></td>
            		        </tr>
            		        <tr>
            		            <td width='3%' rowspan="5" class='title'>사<br>
                					업<br>
                					자<br>
                					등<br>
                					록<br>
                					증</td>
            		            <td width="10%" class='title'>상호</td>
            		            <td width="37%" align='left'>&nbsp;<%=client.getFirm_nm()%></td>
            		            <td class='title' width=13%>대표자</td>
            		            <td width="37%">&nbsp;<%=client.getClient_nm()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>사업자번호<br/>
            		            </td>
            		            <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>
								<%if(!client.getTaxregno().equals("")){%>
								(종사업자번호:<%=client.getTaxregno()%>)
								<%}%>
								</td>
            		            <td class='title'>법인번호</td>
            		            <td>&nbsp;<%=client.getSsn1()%>-<%=client.getSsn2()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>사업장 주소</td>
            		            <td colspan='3'>
                        		              <%if(!client.getO_addr().equals("")){%>
                        		              ( 
                        		              <%}%>
                        		              <%=client.getO_zip()%> 
                        		              <%if(!client.getO_addr().equals("")){%>
                        		              )&nbsp; 
                        		              <%}%>
                        		              <%=client.getO_addr()%>
                        		</td>
            		        </tr>									
            		        <tr>
            		            <td class='title'>본점소재지</td>
            		            <td colspan='3'>&nbsp;
            		            <%if(!client.getHo_addr().equals("")){%>
            		              ( 
            		              <%}%>
            		              <%=client.getHo_zip()%> 
            		              <%if(!client.getHo_addr().equals("")){%>
            		              )&nbsp; 
            		              <%}%>
            		              <%=client.getHo_addr()%>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>업태</td>
            		            <td>&nbsp;<%=client.getBus_cdt()%></td>
            		            <td class='title'>종목</td>
            		            <td>&nbsp;<%=client.getBus_itm()%></td>
            		        </tr>
            		        <tr>
            		            <td rowspan="4" class='title'>대<br>
                					표<br>
                					자</td>
            		            <td class='title'>대표자구분</td>
            		            <td>&nbsp;
            			        <%if(client.getRepre_st().equals("1")) 		out.println("지배주주");
            	                   	else if(client.getRepre_st().equals("2"))	out.println("전문경영인");%>
            	                </td>
            		            <td class='title'>생년월일</td>
            		            <td>&nbsp;<%=client.getRepre_ssn1()%>-<%if(client.getRepre_ssn2().length() > 1){%><%=client.getRepre_ssn2().substring(0,1)%><%}%>******</td>				  
            				</tr>
            		        <tr>
            		            <td class='title'>주소</td>
            		            <td colspan="3">
            		                <table width=100% border=0 cellspacing=0 cellpadding=3>
            		                    <tr>
            		                        <td>
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              ( 
                        		              <%}%>
                        		              <%=client.getRepre_zip()%> 
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              )&nbsp; 
                        		              <%}%>
                        		              <%=client.getRepre_addr()%>
                        		            </td>
                        		        </tr>
                        		    </table>
                        		</td>
            		        </tr>
            		        <tr>
            		            <td class='title'>이메일주소</td>
            		            <td colspan="3">&nbsp;<%=client.getRepre_email()%></td>
            		        </tr>            		                    		        
            		        <tr>
            		            <td class='title'>휴대폰번호</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
            		            <td class='title'>자택번호</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>사무실번호</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
            		            <td class='title'>팩스번호</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>Homepage</td>
            		            <td colspan="3">&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
            		        </tr>
    		            </table>
    			    </td>
    		    </tr>
        	</table>
	    </td>
    </tr>	  
    <tr id=tr_acct2 style="display:<%if(client.getClient_st().equals("1") || client.getClient_st().equals("2") ){%>none<%}else{%>''<%}%>">
	    <td colspan="2">
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 
    		    <tr>
    			    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>개인사업자</span></td>
    		    </tr>
    		    <tr>
                    <td class=line2 colspan=2></td>
                </tr> 
    		    <tr>
    			    <td class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <tr>
            		            <td width='3%' rowspan="5" class='title'>사<br>
                			      업<br>
                			      자<br>
                			      등<br>
                		    	  록<br>
                			      증</td>
            		            <td class='title' width='10%'>개업년월일 </td>
            		            <td colspan="3">&nbsp;<%= client.getOpen_year()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>상호</td>
            		            <td width="37%" align='left'>&nbsp;<%= client.getFirm_nm()%></td>
            		            <td class='title'>대표자</td>
            		            <td width="37%">&nbsp;<%= client.getClient_nm()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>사업자번호<br/>
            		            </td>
            		            <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
            		            <td class='title'>생년월일</td>
            		            <td>&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******</td>
            		        </tr>
            		        <tr>
            		            <td class='title'>사업장 소재지</td>
            		            <td colspan='3'>&nbsp;
            		              <%if(!client.getO_addr().equals("")){%>
            		              ( 
            		              <%}%>
            		              <%=client.getO_zip()%> 
            		              <%if(!client.getO_addr().equals("")){%>
            		              )&nbsp; 
            		              <%}%>
            		              <%=client.getO_addr()%>
            		            </td>
            		        </tr>
            		        <tr>
            		            <td class='title'>업태</td>
            		            <td>&nbsp;<%= client.getBus_cdt()%></td>
            		            <td class='title'>종목</td>
            		            <td>&nbsp;<%= client.getBus_itm()%></td>
            		        </tr>            		     
            		        <tr>
            		            <td rowspan="4" class='title'>대<br>
            					표<br>
            					자</td>
            					<td class='title'>대표자구분</td>
            					<td>&nbsp;
                		            <select name='repre_st'>
                		              <option value="">선택</option>
                		              <option value="1">지배주주</option>
                		              <option value="2">전문경영인</option>
                		            </select>
                		            &nbsp;&nbsp;
                		            이름 : <input type='text' size='10' name='repre_nm' value='' maxlength='50' class='text' value='' OnBlur="checkSpecial();">
                		            (공동대표로 다중일 경우 대표자 공동임차인)
                		            </td>
            		            <td class='title'>생년월일</td>
            		            <td>&nbsp;<%=client.getRepre_ssn1()%>-<%if(client.getRepre_ssn2().length() > 1){%><%=client.getRepre_ssn2().substring(0,1)%><%}%>******</td>
            		            </tr>
            		            <tr>
            		            <td class='title'>주소</td>
            		            <td colspan="3">
            		                <table width=100% border=0 cellspacing=0 cellpadding=3>
            		                    <tr>
            		                        <td>
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              ( 
                        		              <%}%>
                        		              <%=client.getRepre_zip()%> 
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              )&nbsp; 
                        		              <%}%>
                        		              <%=client.getRepre_addr()%>
                        		            </td>
                        		        </tr>
                        		    </table>
                        		</td>
            				</tr>
            				<tr>
            		            <td class='title'>이메일주소</td>
            		            <td colspan="3">&nbsp;<%=client.getRepre_email()%></td>
            		        </tr>
            		        <tr>
            		            <td class='title'>휴대폰번호</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
            		            <td class='title'>자택번호</td>
            		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
            		        </tr>		     
            		        <tr>
            		            <td colspan="2" class='title'>사무실번호</td>
            		            <td>&nbsp;<%= client.getO_tel()%></td>
            		            <td class='title'>팩스번호</td>
            		            <td>&nbsp;<%= client.getFax()%></td>
            		        </tr>
            		        <tr>
            		            <td colspan="2" class='title'>Homepage</td>
            		            <td colspan="3">&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
            		        </tr>
    		            </table>
    			    </td>
    		   </tr>
        	</table>
	    </td>
    </tr>	    
    <tr id=tr_acct3 style="display:<%if(client.getClient_st().equals("2")){%>''<%}else{%>none<%}%>"> 
	<td colspan="2">
	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 	  
    		<tr>
    		    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>개인</span></td>
    		</tr>
    		<tr>
    		    <td class=line2></td>
    		</tr>
    		<tr>
    		    <td class=line>
        		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
        		        <tr>
        		            <td colspan="2" class='title'>성명</td>
        		            <td align='left'>&nbsp;<%=client.getFirm_nm()%></td>
        		            <td class='title'>생년월일</td>
        		            <td>&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******</td>
        		        </tr>
        		        <tr>
        		            <td colspan="2" class='title'>자택주소</td>
        		            <td colspan='3'>&nbsp;
        		         	  <%if(!client.getHo_addr().equals("")){%>
        		              ( 
        		              <%}%>
        		              <%=client.getHo_zip()%> 
        		              <%if(!client.getHo_addr().equals("")){%>
        		              )&nbsp; 
        		              <%}%>
        		              <%=client.getHo_addr()%>
        					    </td>
        		        </tr>
        		        <tr>
        		            <td colspan="2" class='title'>휴대폰</td>
        		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
        		            <td class='title'>자택전화번호</td>
        		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
        		        </tr>
        		        <tr>
        		            <td colspan="2" class='title'>국적</td>
        		            <td>&nbsp;<%if(client.getNationality().equals("2")) 		out.println("외국인");
		            	               	else 											out.println("내국인");%></td>						
        		            <td class='title'>Homepage</td>
        		            <td>&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
        		        </tr>
        		        <tr>
        		            <td width="3%" rowspan="6" class='title'>소<br>
            		            득<br>정<br>
            		            보</td>
        		            <td width="10%" class='title'>직업</td>
        		            <td width="37%">&nbsp;<%=client.getJob()%></td>
        		            <td width="13%" class='title'>소득구분</td>
        		            <td width="37%">&nbsp; 
            		            <%if(client.getPay_st().equals("1")) 		out.println("급여소득");
            	              	else if(client.getPay_st().equals("2"))    out.println("사업소득");
            	               	else if(client.getPay_st().equals("3"))	out.println("기타사업소득");%>
        	                </td>
        		        </tr>
        		        <tr>
        		            <td class='title'>직장명</td>
        		            <td colspan="3">&nbsp;<%=client.getCom_nm()%></td>
        		        </tr>
        		        <tr>
        		            <td class='title'>부서명</td>
        		            <td>&nbsp;<%=client.getDept()%></td>
        		            <td class='title'>직위</td>
        		            <td>&nbsp;<%=client.getTitle()%></td>
        		        </tr>
        		        <tr>
        		            <td class='title'>전화번호</td>
        		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
        		            <td class='title'>FAX</td>
        		            <td>&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
        		        </tr>
        		        <tr>
        		            <td class='title'>직장주소</td>
        		            <td colspan="3">&nbsp;
        		            <%if(!client.getComm_addr().equals("")){%>
        		              ( 
        		              <%}%>
        		              <%=client.getComm_zip()%> 
        		              <%if(!client.getComm_addr().equals("")){%>
        		              )&nbsp; 
        		              <%}%>
        		              <%=client.getComm_addr()%>
        		            </td>   
        		        </tr>
        		        <tr>
        		            <td class='title'>근속연수</td>
        		            <td>&nbsp;<%=client.getWk_year()%>년</td>
        		            <td class='title'>연소득</td>
        		            <td>&nbsp;<%=client.getPay_type()%>만원</td>
        		        </tr>
        		        <tr>
            		          <td rowspan="3" class='title'>대<br>
                					표<br>
                					자</td>
            		            <td class='title'>대표자구분</td>
            		            <td>&nbsp;
            	                   이름 : <%=client.getRepre_nm()%>	(공동임차인)
            	                </td>
            		            <td class='title'>생년월일</td>
            		            <td>&nbsp;<%=client.getRepre_ssn1()%>-<%if(client.getRepre_ssn2().length() > 1){%><%=client.getRepre_ssn2().substring(0,1)%><%}%>******</td>				  
            				</tr>
            		        <tr>
            		            <td class='title'>주소</td>
            		            <td colspan="3">
            		                <table width=100% border=0 cellspacing=0 cellpadding=3>
            		                    <tr>
            		                        <td>
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              ( 
                        		              <%}%>
                        		              <%=client.getRepre_zip()%> 
                        		              <%if(!client.getRepre_addr().equals("")){%>
                        		              )&nbsp; 
                        		              <%}%>
                        		              <%=client.getRepre_addr()%>
                        		            </td>
                        		        </tr>
                        		    </table>
                        		</td>
            		        </tr>
            		        <tr>
            		            <td class='title'>이메일주소</td>
            		            <td colspan="3">&nbsp;<%=client.getRepre_email()%></td>
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
	    <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>공통</span></td>
    </tr>
    <tr>
	    <td class=line2 colspan="2"></td>
	</tr>  
	<tr>
	    <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
	        	    <tr>
                    <td class='title'>운전면허번호</td>
                    <td colspan="3">&nbsp;<%=client.getLic_no()%></td>
                </tr>		
                <tr>
                    <td width="15%" rowspan='2' class='title'>세금계산서<br>
                        수신담당자</td>
                    <td colspan='3'>&nbsp;성명:<%=client.getCon_agnt_nm()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;사무실:<%=AddUtil.phoneFormat(client.getCon_agnt_o_tel())%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이동전화:<%=AddUtil.phoneFormat(client.getCon_agnt_m_tel())%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAX:<%=AddUtil.phoneFormat(client.getCon_agnt_fax())%>
        		    </td>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;EMAIL:<%=client.getCon_agnt_email()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;근무부서:<%=client.getCon_agnt_dept()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;직위:<%=client.getCon_agnt_title()%>
                    </td>
                </tr>
                <tr>
                    <td width="15%" rowspan='2' class='title'>세금계산서<br>
                        추가담당자</td>
                    <td colspan='3'>&nbsp;성명:<%=client.getCon_agnt_nm2()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;사무실:<%=AddUtil.phoneFormat(client.getCon_agnt_o_tel2())%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이동전화:<%=AddUtil.phoneFormat(client.getCon_agnt_m_tel2())%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAX:<%=AddUtil.phoneFormat(client.getCon_agnt_fax2())%>
        		    </td>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;EMAIL:<%=client.getCon_agnt_email2()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;근무부서:<%=client.getCon_agnt_dept2()%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;직위:<%=client.getCon_agnt_title2()%>
                    </td>
                </tr>                       
                <tr>
                    <td class='title'>이메일수신거부사유</td>
                    <td colspan="3">&nbsp;<%=client.getEtax_not_cau()%></td>
                </tr>	
                <tr>
                    <td class='title'>거래명세서메일수신여부</td>
                    <td width="35%">&nbsp;
                     <%  if(client.getItem_mail_yn().equals("N")) 	out.println("거부");
                      	else   										out.println("승락");
                     	%>
                    </td>
                    <td width="15%" class='title'>세금계산서메일수신여부</td>
                    <td width="35%">&nbsp;
					<%  if(client.getTax_mail_yn().equals("N")) 	out.println("거부");
                      	else   										out.println("승락");
                     	%>
					</td>
                </tr>					
                <tr>
                    <td class='title'>계산서발행구분</td>
                    <td width="35%">&nbsp;
                     <%if(client.getPrint_st().equals("1")) 		out.println("계약건별");
                      	else if(client.getPrint_st().equals("2"))   out.println("거래처통합");
                      	else if(client.getPrint_st().equals("3")) 	out.println("지점통합");
                     	else if(client.getPrint_st().equals("4"))	out.println("현장통합");
						else if(client.getPrint_st().equals("5"))	out.println("승합/화물/9인승/경차");
                     	else if(client.getPrint_st().equals("9"))	out.println("타시스템발행");
                     	%>
                    </td>
                    <td class='title'>계산서별도발행구분</td>
                    <td >&nbsp;
					<%  if(client.getPrint_car_st().equals("1"))	out.println("승합/화물/9인승/경차");
                      	else   										out.println("없음");
                     	%>
					</td>
                </tr>			
                <tr>                    
                    <td class='title'>임의연장계산서발행구분</td>
                    <td >&nbsp;
					<%  if(client.getIm_print_st().equals("Y"))		out.println("고객발행구분 그대로");
                      	else   										out.println("무조건 개별발행");
                     	%>
					</td>
					<td class='title'>계산서 회차 표시 여부</td>
                    <td>&nbsp;
					<%  if (client.getTm_print_yn().equals("N")) 		out.println("미표시");
                      	else if (client.getTm_print_yn().equals("")) 	out.println("표시");
                     	%>                      
					</td>														
                </tr>								
                <tr>			
                    <td width="15%" class='title'>계산서 비고 표시 여부</td>
                    <td>&nbsp;
					<%  if(client.getBigo_yn().equals("N")) 		out.println("미표시");
						else if(client.getBigo_yn().equals("A"))    out.println("기본+추가삽입분 표시");
						else if(client.getBigo_yn().equals("B"))    out.println("추가삽입분만 표시");
                      	else   										out.println("기본만 표시");
                     	%>						
					</td>
                    <td class='title'>계산서품목표시구분</td>
                    <td>&nbsp;
					<%  if(client.getEtax_item_st().equals("2")) 	out.println("모두표시");
                      	else   										out.println("한줄만표시");
                     	%>						
					</td>
                </tr>
                <tr>
                    <td class='title'>계산서비고 추가삽입</td>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 
					고정값 : <%=client.getBigo_value1()%>
					&nbsp;&nbsp;
					<img src=/acar/images/center/arrow.gif align=absmiddle>
					변동값 : NO.<%=client.getBigo_value2()%>
					&nbsp;(변동값은 숫자만 가능합니다. 계산서 발행시 이값에 1을 증가하여 비고에 표시합니다.)
					</td>	                    							
                </tr>					
                <tr>
                    <td class='title'>계산서 청구발행 구분</td>
                    <td >&nbsp;
					<%  if(client.getPubform().equals("R")) 		out.println("영수");
                      	else   										out.println("청구");
                     	%>
					</td>
                    <td class='title'>연체문자수신여부</td>
                    <td >&nbsp;
					<%  if(client.getDly_sms().equals("N")) 		out.println("거부");
                      	else   										out.println("승락");
                     	%>
					</td>
                </tr>						
                <tr>
                    <td class='title'>면책금 청구 여부</td>
                    <td>&nbsp;
					<%  if (client.getEtc_cms().equals("N")) 		out.println("거부");
                      	else if (client.getEtc_cms().equals("Y")) 	out.println("승락");
                      	else  										out.println("  ");
                     	%>
                      &nbsp;&nbsp;* CMS 거래고객에 한함.	
					</td>
					<td class='title'>선납과태료 청구 여부</td>
                    <td>&nbsp;
					<%  if (client.getFine_yn().equals("N")) 		out.println("거부");
                      	else if (client.getFine_yn().equals("Y")) 	out.println("승락");
                      	else  										out.println("  ");
                     	%>
                      &nbsp;&nbsp; 
					</td>
                </tr>				
                       <tr>
                    <td class='title'>연체이자 CMS 청구 여부</td>
                    <td >&nbsp;
					<%  if (client.getDly_yn().equals("N")) 		out.println("거부");
                      	else if (client.getDly_yn().equals("Y")) 	out.println("승락");
                      	else  										out.println("  ");
                     	%>
                      &nbsp;&nbsp;* CMS 거래고객에 한함.	
					</td>
                    <td class='title'>CMS요청문자수신여부</td>
                    <td >&nbsp;
					<%  if (client.getCms_sms().equals("N")) 		out.println("거부");
                      	else if (client.getCms_sms().equals("Y")) 	out.println("승락");
                      	else  										out.println("  ");
                     	%>                      
					</td>		
                </tr>					                
                <tr>
                    <td class='title'>네오엠코드</td>
                    <td>&nbsp;<%if(!client.getVen_code().equals("")){%><%=client.getVen_code()%><%}%></td>
                    <td class='title'>차량사용용도</td>
                    <td>&nbsp;<%=client.getCar_use()%></td>
                </tr>						
                <tr>
                    <td class='title'> 특이사항 </td>
                    <td colspan='3'>&nbsp;
        		        <table border="0" cellspacing="1" cellpadding="4" width=650 height='40'>
                            <tr>
                                <td><%=Util.htmlBR(client.getEtc())%> </td>
                            </tr>
                        </table>
        		    </td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>    

</table>   




</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--
	var fm = document.form1;
	<%	if(from_page.equals("")){%>
	//바로가기
	/*
	var s_fm = parent.parent.top_menu.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.c_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = fm.client_id.value;
	s_fm.accid_id.value = "";
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
	*/
	<%}%>
//-->
</script>  
</body>
</html>
