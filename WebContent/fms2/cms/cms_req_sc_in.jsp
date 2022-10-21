<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cms.CmsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	Vector vt = ac_db.getCmsReqList(s_kd, t_wd, gubun1, andor);
	
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
			
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='43%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>
			       <td width='14%' class='title' >연번</td>				
		            <td width='20%' class='title'>계약번호</td>
        		    <td width='17%' class='title'>요청일</td>
		           <td width='12%' class='title'>요청자</td>		 
		             <td width='23%' class='title'>고객</td>		       
		           <td width='14%' class='title'>차량번호</td>		         	
				</tr>
			</table>
		</td>
		<td class='line' width='57%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					 <td class='title' width='13%'>은행</td>
					 <td class='title' width='13%'>계좌번호</td>					
					 <td class='title' width='20%' >예금주</td>	
				  	 <td width="18%" class='title'>통장사본</td>		
				  	 <td class='title' width='18%' >CMS동의서</td>		
				 	 <td width="6%" class='title'>구분</td>			 				 						
				</tr>
				
			</table>
		</td>
    </tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='43%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
		    				
				String m_id = String.valueOf(ht.get("RENT_MNG_ID"));
				String l_cd = String.valueOf(ht.get("RENT_L_CD"));

%>
				<tr>
					<td  width='14%' align='center'><%=i+1%></td>				
					 <td  width='20%' align='center'>
					   <a href="javascript:parent.view_action('<%=m_id%>', '<%=l_cd%>','<%=String.valueOf(ht.get("REQ_DT"))%>' )" onMouseOver="window.status=''; return true"><%=l_cd%></a></td> 
					<td width='17%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>			
					<td  width='12%' align='center'><%=ht.get("BUS_NM")%>	</td>	
					<td  width='23%' align='left'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 9)	%></td>	
					<td  width='14' align='center'><%=ht.get("CAR_NO")%></td>				
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='57%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
					
			String m_id = String.valueOf(ht.get("RENT_MNG_ID"));
			String l_cd = String.valueOf(ht.get("RENT_L_CD"));
			
			
							
%>			
				<tr>
					<td   width='13%' align='center'><%=Util.subData(String.valueOf(ht.get("CMS_BANK")), 6)%></td>										
					<td   width='13%' align='center'><%=ht.get("CMS_ACC_NO")%></td> 
					<td  width='20%' align='center'><%=Util.subData(String.valueOf(ht.get("CMS_DEP_NM")), 12)%></td>					
					<td   width='18%'  align="center">&nbsp;
                    <%
                	String content_code  = "LC_SCAN";
                	                     
                	Vector attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, m_id, l_cd, "9", 0);
                	int attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j <1 ; j++){
 					Hashtable ht1 = (Hashtable)attach_vt.elementAt(j);          
                    %>                
                    
                                <a href="javascript:openPopP('<%=ht1.get("FILE_TYPE")%>','<%=ht1.get("SEQ")%>');" title='보기' ><%=Util.subData(String.valueOf(ht1.get("FILE_NAME")), 10)%></a>
        
                    <%		}
                	}
                    %>         
                    </td>                  
                   <td   width='18%' align="center"> &nbsp;
                    <%
                	content_code  = "LC_SCAN";
              
                   	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, m_id, l_cd, "38", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
			         	for (int j = 0 ; j < 1 ; j++){
 				        	Hashtable ht1 = (Hashtable)attach_vt.elementAt(j);      
 				        	    
                    %>                
                    
                                <a href="javascript:openPopP('<%=ht1.get("FILE_TYPE")%>','<%=ht1.get("SEQ")%>');" title='보기' ><%=Util.subData(String.valueOf(ht1.get("FILE_NAME")), 10)%></a>
        
                    <%		}
                	}
                    %>         
                    </td> 
				   <td  width='6%' align='center'>&nbsp;<%=ht.get("APP_ST_NM")%>
				  
			       </td>
				</tr>
				
<%
		}
%>
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='43%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='57%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
