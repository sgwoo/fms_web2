<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cms_db" scope="page" class="acar.cms.CmsDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
					
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
			
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	int count = 0;
	
	//현재날짜와 4일(working day) 이내 신청인 경우 저장 불가 
	String afterday = ad_db.getWorkDay(AddUtil.getDate(4), 4);

 		
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	//등록하기
	function doc_reg(){	
		var fm = document.form1;
		var sh_fm = parent.c_body.document.form1;		
		
		fm.cms_bank.value 	= sh_fm.cms_bank.value;
		fm.cms_acc_no.value 	= sh_fm.cms_acc_no.value;
		fm.cms_dep_nm.value 	= sh_fm.cms_dep_nm.value;		
		fm.cms_dep_ssn.value 	= sh_fm.cms_dep_ssn.value;
		
		if(fm.est_cnt.value != '0')		{ alert("cms변경 기간이 촉박한 계약이 있습니다."); return; }
		
		if(fm.cms_bank.value == '') { alert('거래은행을 확인하십시오.'); return; }
		if(fm.cms_acc_no.value == '') { alert('계좌번호를 확인하십시오.'); return; }
		if(fm.cms_dep_nm.value == '') { alert('예금주를 확인하십시오.'); return; }
		if(fm.cms_dep_ssn.value == '') { alert('예금주 생년월일/사업자번호를 확인하십시오.'); return; }	
	
		if(fm.size.value == '0')		{ alert('건수를 확인 하십시오.'); return; }
		
		if(fm.client_cnt.value != '0')		{ alert("상호를 확인하세요. 사업자(주민번호가) 틀립니다."); return; }
	 			
		var su = fm.size.value;
		
		fm.ok.value= '0';
					   		 
		for(i=0; i<su ; i++){
			if ( fm.reg_cnt[i].value == '2') {  
				   fm.ok.value= '1';			   
			}	
						
		}
				
		if ( fm.ok.value == '0'  ) { 		
			 { alert('1건이상  통장사본, CMS동의서를 스캔등록한후 진행하세요.'); return;}
		}
		
		
		if(!confirm('등록하시겠습니까?')){	return;	}
		fm.action = "cms_reg_etc_sc_a.jsp";
		fm.target = "i_no";
		fm.submit()
	}	
	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}		
	
	
//-->
</script>


</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='cms_bank' >
<input type='hidden' name='cms_acc_no'   >
<input type='hidden' name='cms_dep_nm'   >
<input type='hidden' name='cms_dep_ssn'   >
<input type='hidden' name='ok'   >

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>  
                    <td class=title width=4%>연번</td>                                
                    <td class=title width=12%>계약번호</td>
                    <td class=title width=10%>차량번호</td>
                    <td class=title width=14%>변경전 거래은행</td>
                    <td class=title width=14%>변경전 계좌번호</td>  
                    <td width="18%" class='title'>통장사본</td>		
				  	<td class='title' width='18%' >CMS동의서</td>	
				    <td class=title width=6%>인출예정일</td>   	
                    <td class=title width=4%>적용</td>   
                </tr>
<% 	
	//선택리스트
	
	String vid[] = request.getParameterValues("rld");
	
	String vid_num="";
	String ch_rent_mng_id="";
	String ch_rent_l_cd="";
	String ch_old_bank="";
	String ch_old_accno="";
	String ch_car_no="";
	String ch_client_id="";
	String old_client_id = "";
	String est_dt = "";
	
	int cnt9 = 0;
	int cnt38 = 0;
	
	int client_cnt = 0;
	int est_cnt = 0;
	
	Hashtable ht = new Hashtable();
	
	String content_code = "";
	
	Vector attach_vt =new Vector();
	 int attach_vt_size =0;
   				
	for(int i=0; i<vid.length;i++){
		vid_num=vid[i];
			
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {				
				ch_rent_mng_id = token1.nextToken().trim();	 
				ch_rent_l_cd= token1.nextToken().trim();	 
				ch_client_id = token1.nextToken().trim();	
			
			    if ( i == 0 )      old_client_id  = ch_client_id;			   
								
			  	if ( !old_client_id.equals(ch_client_id) )    	  client_cnt++;
			  	 
			 
			// 변경전 cms 정보  		
			//자동이체정보
			ContCmsBean cms 	= a_db.getCmsMng(ch_rent_mng_id, ch_rent_l_cd);
			ch_old_bank=cms.getCms_bank();			
			ch_old_accno=cms.getCms_acc_no();	
			
			est_dt = cms_db.getCmsFeeEst_dt(ch_rent_mng_id, ch_rent_l_cd); //인출예정일 
		
			if ( AddUtil.parseInt(est_dt) <  AddUtil.parseInt(afterday) )  est_cnt ++;
							
			ht =  a_db.getContViewCase(ch_rent_mng_id, ch_rent_l_cd); //계약정보 
						
				//첨부파일이 등록되었는지 확인 - 당일날짜로 확인 
			cnt9 = cms_db.getCmsCngFileCnt(ch_rent_l_cd, AddUtil.getDate(), "9");  //통장사본 
			cnt38 = cms_db.getCmsCngFileCnt(ch_rent_l_cd, AddUtil.getDate(), "38"); //동의서   			
									
		}
     
%>		  
 		        <tr align="center"> 
                    <td><%=i+1%></td>                    
                		<input type='hidden' name='rent_mng_id' value='<%=ch_rent_mng_id%>'>
		        			<input type='hidden' name='rent_l_cd' value='<%=ch_rent_l_cd%>'>
		        			<input type='hidden' name='old_cms_bank' value='<%=ch_old_bank%>'>			
		        			<input type='hidden' name='old_cms_acc_no' value='<%=ch_old_accno%>'>		   
		        			<input type='hidden' name='reg_cnt' value='<%=cnt9+cnt38%>'>	
		        			<input type='hidden' name='ch_client_id' value='<%=ch_client_id%>'>	
		        		      		
                
                    <td><%=ch_rent_l_cd%>&nbsp;&nbsp;
                    <a href="javascript:view_scan('<%=ch_rent_mng_id%>','<%=ch_rent_l_cd%>');" class="btn" title='스캔관리'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
                                        </td>
                    <td><%=String.valueOf(ht.get("CAR_NO"))%></td>
                    <td><%=ch_old_bank%></td>
                    <td><%=ch_old_accno%></td>     
                    <td   width='18%' align="center"> &nbsp;     
                   <% if ( cnt9 < 1 ) { %>
                      &nbsp;
                   <% } else { %> 
		             <%   	content_code  = "LC_SCAN";
		                	                     
		                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, ch_rent_mng_id, ch_rent_l_cd, "9", 0);
		                	attach_vt_size = attach_vt.size();
		                	
		                	if(attach_vt_size > 0){
									for (int j = 0 ; j <1 ; j++){
		 								Hashtable ht1 = (Hashtable)attach_vt.elementAt(j);          
		                    %>                
                    
                                <a href="javascript:openPopP('<%=ht1.get("FILE_TYPE")%>','<%=ht1.get("SEQ")%>');" title='보기' ><%=Util.subData(String.valueOf(ht1.get("FILE_NAME")), 10)%></a>
        
	                    <%		}
	                	}   
	                   } %>
                    </td>                  
                   <td   width='18%' align="center"> &nbsp;
                     <% if ( cnt38 < 1 ) { %>
                      &nbsp;
                   <% } else { %> 
                    <%
                	content_code  = "LC_SCAN";
              
                   	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, ch_rent_mng_id, ch_rent_l_cd, "38", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
			         	for (int j = 0 ; j < 1 ; j++){
 				        	Hashtable ht1 = (Hashtable)attach_vt.elementAt(j);      
 				        	    
                    %>                
                    
                                <a href="javascript:openPopP('<%=ht1.get("FILE_TYPE")%>','<%=ht1.get("SEQ")%>');" title='보기' ><%=Util.subData(String.valueOf(ht1.get("FILE_NAME")), 10)%></a>
        
                    <%		}
                	}
                   } %>         
                    </td>   
                    <td align=center><%=est_dt%></td>  
                    <td align=right></td>
                </tr>

<%		
       count++;
       
       old_client_id  = ch_client_id;
	}%>		
		    <input type='hidden' name='size' value='<%=count%>'>  
		    <input type='hidden' name='client_cnt' value='<%=client_cnt%>'>  
		    <input type='hidden' name='est_cnt' value='<%=est_cnt%>'>  
		 
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	    <a href='javascript:doc_reg()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    <%}%>
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
