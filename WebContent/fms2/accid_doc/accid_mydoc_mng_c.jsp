<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.estimate_mng.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
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
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
	//손해금청구리스트
	Vector FineList = FineDocDb.getAccidMyDocLists(doc_id);
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "HEAD", "Y");
	int user_size = users.size();
	Vector users2 = c_db.getUserList("", "", "BODY", "Y");
	int user_size2 = users2.size();
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	//변수
	String u_var1 = e_db.getEstiSikVarCase("1", "", "myaccid_id1");//담당부서장
	String u_var2 = e_db.getEstiSikVarCase("1", "", "myaccid_id2");	//담당자
	String d_var1 = e_db.getEstiSikVarCase("1", "", "myaccid_app1");//첨부서류1
	String d_var2 = e_db.getEstiSikVarCase("1", "", "myaccid_app2");//첨부서류2
	String d_var3 = e_db.getEstiSikVarCase("1", "", "myaccid_app3");//첨부서류3
	String d_var4 = e_db.getEstiSikVarCase("1", "", "myaccid_app4");//첨부서류4	
	String d_var5 = e_db.getEstiSikVarCase("1", "", "myaccid_app5");//첨부서류5
	String d_var6 = e_db.getEstiSikVarCase("1", "", "myaccid_app6");//첨부서류6
	String d_var7 = e_db.getEstiSikVarCase("1", "", "myaccid_app7");//첨부서류7
	String d_var8 = e_db.getEstiSikVarCase("1", "", "myaccid_app8");//첨부서류8
	String d_var9 = e_db.getEstiSikVarCase("1", "", "myaccid_app9");//첨부서류9
	String d_var10 = e_db.getEstiSikVarCase("1", "", "myaccid_app10");//첨부서류10
	String d_var11 = e_db.getEstiSikVarCase("1", "", "myaccid_app11");//첨부서류11
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//수정하기
	function fine_upd(){
		window.open("accid_mydoc_mng_u.jsp?doc_id=<%=doc_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>", "REG_FINE_GOV", "left=100, top=200, width=860, height=400, resizable=yes, scrollbars=yes, status=yes");
	}
	
	//리스트수정하기
	function list_save(doc_id, car_mng_id, seq_no){
		window.open("accid_mydoc_mng_list_u.jsp?doc_id=<%=doc_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&car_mng_id="+car_mng_id+"&seq_no="+seq_no, "REG_FINE_LIST", "left=100, top=100, width=1060, height=400, resizable=yes, scrollbars=yes, status=yes");
	}
		
	//목록보기
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "accid_mydoc_mng_frame.jsp";
		fm.submit();
	}			
	
	//계약정보 보기
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//필요서류
	function DocSelect(m_id, l_cd, c_id, accid_id, seq_no, client_id){
		var fm = document.form1;
		var SUBWIN="/acar/accid_mng/myaccid_reqdoc_select.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&seq_no="+seq_no+"&client_id="+client_id+"&from_page=/fms2/accid_doc/accid_mydoc_mng_c.jsp";			
		window.open(SUBWIN, "DocSelect", "left=50, top=50, width=950, height=600, resizable=yes, scrollbars=yes, status=yes");	
	}

	//출력하기
	function FineDocPrint(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "accid_mydoc_print.jsp";
		fm.submit();
	}
	


//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > <span class=style5>대차료청구공문관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>    
        <td align="right" >
		  <%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%>
	  	 	  <a href="javascript:fine_upd();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a>&nbsp;
		  <%}%>
			  <a href="javascript:go_list();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif"  align="absmiddle" border="0"></a>
		 </td>
			  
         
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line" width="100%"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=13%>문서번호</td>
                    <td width=87%>&nbsp;<%=FineDocBn.getDoc_id()%></td>
                </tr>
                <tr> 
                    <td class='title'>시행일자</td>
                    <td>&nbsp;<%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></td>
                </tr>
                <tr> 
                    <td class='title'>수신</td>
                    <td>&nbsp;<%=FineDocBn.getGov_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>참조</td>
                    <td>&nbsp;<%=FineDocBn.getMng_dept()%> 
        			<%if(!FineDocBn.getMng_nm().equals("")){%>						
        			(담당자 : <%=FineDocBn.getMng_nm()%> <%=FineDocBn.getMng_pos()%>) 
        			<%}%>						
        			</td>
                </tr>
                <tr> 
                    <td class='title'>제목</td>
                    <td>&nbsp;대차료 청구</td>
                </tr>
                <tr> 
                    <td class='title'>내용</td>
                    <td>&nbsp;1. 귀 사의 무궁한 발전을 기원합니다.<br>
						&nbsp;2. 아래와 같이 대차료를 청구하오니 결재바랍니다.
					</td>
                </tr>		  
                <tr> 
                    <td class='title'>첨부</td>
                    <td>
						<table cellspacing="2" cellpadding="2" border="0">
							<tr>
    							<td>&nbsp;&nbsp;&nbsp;&nbsp; 아마존카 사업자등록증 1부
									&nbsp;&nbsp;&nbsp;&nbsp; 아마존카 단기대여요금표 1부
									&nbsp;&nbsp;&nbsp;&nbsp; 아마존카 신한은행 통장 사본 1부</td>
							</tr>
							<%		int s=0;
									String value[] = new String[11];
									
									if(!FineDocBn.getApp_docs().equals("")){
								  		StringTokenizer st = new StringTokenizer(FineDocBn.getApp_docs(),"^");
										
										while(st.hasMoreTokens()){
											value[s] = st.nextToken();
											s++;
										}
								  	}else{
										for(int i=0; i<11; i++){
											value[i] = "N";
										}
									}%>
							<tr>
							    <td>
								  <input type="checkbox" name="app_doc4"  value="Y" <%if(s>0 && value[3].equals("Y")){%>checked<%}%>><%=d_var4%>
								  <input type="checkbox" name="app_doc5"  value="Y" <%if(s>0 && value[4].equals("Y")){%>checked<%}%>><%=d_var5%>
								  <br>
								  <input type="checkbox" name="app_doc6"  value="Y" <%if(s>0 && value[5].equals("Y")){%>checked<%}%>><%=d_var6%>
								  <input type="checkbox" name="app_doc7"  value="Y" <%if(s>0 && value[6].equals("Y")){%>checked<%}%>><%=d_var7%>
								  <br>
								  <input type="checkbox" name="app_doc8"  value="Y" <%if(s>0 && value[7].equals("Y")){%>checked<%}%>><%=d_var8%>
								  <!--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="app_doc9"  value="Y" <%if(s>0 && value[8].equals("Y")){%>checked<%}%>><%=d_var9%>-->
								  <br>
								  <input type="checkbox" name="app_doc10" value="Y" <%if(s>0 && value[9].equals("Y")){%>checked<%}%>><%=d_var10%>
								  <input type="checkbox" name="app_doc11" value="Y" <%if(s>10 && value[10].equals("Y")){%>checked<%}%>><%=d_var11%>
								  </td>
							</tr>
						</table>
        			</td>
                </tr>	
                <tr> 
                    <td class='title'>등기번호</td>
                    <td>&nbsp;<%=FineDocBn.getPost_num()%></td>
                </tr>	  		  
            </table>
        </td>
    </tr>
    <tr>     
        <td></td>    
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>당사</span></td>
    </tr>
    <tr>     
        <td class=line2></td>    
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width=13% class='title'>담당부서장</td>
                    <td width=37%><select name='h_mng_id' disabled>
                        <option value="">없음</option>
                        <%	if(user_size > 0){
            						for (int i = 0 ; i < user_size ; i++){
            							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getH_mng_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
            					}		%>
                        </select></td>
                    <td  width=13% class='title'>담당자</td>
                    <td width=37%><select name='b_mng_id' disabled>
                        <option value="">없음</option>
                        <%	if(user_size2 > 0){
            						for (int i = 0 ; i < user_size2 ; i++){
            							Hashtable user = (Hashtable)users2.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(FineDocBn.getB_mng_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
            					}		%>
                        </select></td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr> 
        <td align="right">
    	  <%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%>
    	  <%	if(FineDocBn.getPrint_dt().equals("")){%>
    	  <a href="javascript:FineDocPrint();"><img src=/acar/images/center/button_print_gm.gif align=absmiddle border=0></a>&nbsp;&nbsp;
    	  <%	}else{%>
    	  <img src=/acar/images/center/arrow_printd.gif align=absmiddle> : <a href="javascript:FineDocPrint();"><%=AddUtil.ChangeDate2(FineDocBn.getPrint_dt())%> (<%=c_db.getNameById(FineDocBn.getPrint_id(), "USER")%>)</a>&nbsp;&nbsp;
    	  <%	}%>	  
    	  <%}%>
	    </td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>휴/대차료 리스트</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	          <tr> 
    	        <td width="5%" rowspan="2" class='title' >연번</td>
        	    <td width="10%" rowspan="2" class='title'>사고접수번호</td>
            	<td colspan="2" class='title'>대차이용자</td>
	            <td width="10%" rowspan="2" class='title'>차량번호</td>
    	        <td width="11%" rowspan="2" class='title'>차명</td>			
        	    <td colspan="3" class='title'>대차기간</td>						
            	<td width="8%" rowspan="2" class='title'>대차료<br>청구금액</td>
	            <td width="12%" rowspan="2" class='title'>필요서류</td>			
    	      </tr>
        	  <tr>
	            <td width="10%" class='title'>성명</td>
    	        <td width="10%" class='title'>사업자/생년월일</td>
        	    <td width="8%" class='title'>개시일시</td>
            	<td width="8%" class='title'>종료일시</td>
	            <td width="8%" class='title'>적산일시</td>
    	      </tr>
              <% if(FineList.size()>0){
    				for(int i=0; i<FineList.size(); i++){ 
    					FineDocListBn = (FineDocListBean)FineList.elementAt(i); %>		  
                <tr align="center"> 
                    <td><%=i+1%></td>
	        		<td align=center><%=FineDocListBn.getPaid_no()%></td>
	        		<td align=center><a href="javascript:view_client('<%=FineDocListBn.getRent_mng_id()%>','<%=FineDocListBn.getRent_l_cd()%>','')" title='장기계약 약식저어보 보기'><%=FineDocListBn.getFirm_nm()%></a></td>
	        		<td align=center><%=AddUtil.ChangeEnt_no(FineDocListBn.getEnp_no())%><%if(FineDocListBn.getEnp_no().equals("")){%><%=AddUtil.ChangeEnpH(FineDocListBn.getSsn())%><%}%></td>			
	        		<td align=center><%=FineDocListBn.getCar_no()%></td>
	        		<td align=center><%=FineDocListBn.getVar3()%></td>
	        		<td align=center><%=FineDocListBn.getRent_start_dt()%></td>
	        		<td align=center><%=FineDocListBn.getRent_end_dt()%></td>
	        		<td align=center><%=FineDocListBn.getVar2()%></td>
	        		<td align=right><a href="javascript:list_save('<%=FineDocListBn.getDoc_id()%>','<%=FineDocListBn.getCar_mng_id()%>','<%=FineDocListBn.getSeq_no()%>')" title='한줄 수정하기'><%=Util.parseDecimal(FineDocListBn.getAmt1())%>원</a></td>
	        		<td align=center><a href="javascript:DocSelect('<%=FineDocListBn.getRent_mng_id()%>','<%=FineDocListBn.getRent_l_cd()%>','<%=FineDocListBn.getCar_mng_id()%>','<%=FineDocListBn.getRent_s_cd()%>','<%=FineDocListBn.getVar1()%>','')" title='청구서류일괄인쇄'><img src="/acar/images/center/button_print_ig.gif" align="absmiddle" border="0"></a></td>
        			</td>
                </tr>
              <% 	}
    			} %>
            </table>
        </td> 
    </tr>
</table>
</form>
</body>
</html>
