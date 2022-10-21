<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_samt.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	
	String st_dt = s_year + s_mon + "01";
	String end_dt = s_year + s_mon + "31";
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();
	
	Vector sers = cs_db.getServNewList3(acct, gubun1, st_dt, end_dt, s_kd, t_wd, sort, asc);
	int ser_size = sers.size();
	
	int amt8_old = 0;
		
	int amt[] 	= new int[13];
	
	String file_path="";
	String theURL = "https://fms3.amazoncar.co.kr/data/";
	String file_ext=".pdf";
	
%>

<html>
<head>
<title>FMS</title>

<script language="JavaScript">
	var popObj = null;
<!--
	/* Title ���� */
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
	function init()
	{		
		setupEvents();
	}
	
	//����: ��ĵ ����
	function view_map(file_path, scan){
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		var map_path = scan;
		var size = 'width=700, height=650, scrollbars=yes';
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+map_path+".pdf";
		popObj =window.open("", "SCAN", "left=50, top=30,"+size+", resizable=yes");
		popObj.location = theURL;
		popObj.focus();
		
	}	
	
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		popObj =window.open(theURL,winName,features);
		popObj.location = theURL;
		popObj.focus();
	}	
		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form name="form1">
<table border="0" cellspacing="0" cellpadding="0" width=1970>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='740' id='td_title' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%' height="43">
                <tr> 
                    <td width='8%' rowspan=2 class='title' style='height:45'>����</td>
                     <td width='6%' rowspan=2 class='title'>������</td>
                    <td width='6%' rowspan=2 class='title'>����</td>
                    <td width='10%' rowspan=2 class='title'>����</td>
                    <td width='10%'  colspan=2 class='title'>���Ǻ���</td>
                    <td width='5%' rowspan=2 class='title'>����</td>
                     <td width='12%' rowspan=2 class='title'>������ȣ</td>
                    <td width='16%' rowspan=2 class='title'>����</td>
                    <td width='11%' rowspan=2 class='title' >��������</td>
           
                </tr>
                  <tr>
                    <td width='5%' class='title'>���</td>
                    <td width='5%' class='title'>���</td>              
            
                </tr>
            </table>
        </td>
		<td class='line' width='1230'>			
	        <table border="0" cellspacing="1" cellpadding="0" width='1230'>
                <tr>
                   <td width='80' rowspan=2 class='title'>�԰�����</td>
        		 <td width='80' rowspan=2 class='title'>�������</td>             		
                 	<td width='60'  rowspan=2 class='title' style='height:45'>�����</td>
        		<td width='170' rowspan=2 class='title'>��</td>			  		
                    <td width='200' rowspan=2 class='title'>����</td>
                 	<td width='80'  class="title" rowspan=2 >����ݾ�</td>
                <!--    <td  class="title" colspan=4 >���곻��</td> -->
                    <td  class="title" colspan=5 >���޳���</td>
                    <td class="title" colspan=2 >��å��</td>    
              
            
          <!--  <td width='40'  class=title rowspan=2>����</td> -->
          
                </tr>
                <tr>
                <!--    <td width='80' class='title'>����</td>
                    <td width='80' class='title'>����</td>
                    <td width='80' class='title'>��ǰ</td>
                    <td width='80' class='title'>�Ұ�</td>
                    <td width='50' class='title'>D/C��</td>
                    <td width='80' class='title'>���� D/C</td> -->
                    <td width='80' class='title'>����</td>
                    <td width='80' class='title'>��ǰ</td>
                    <td width='60' class='title'>D/C</td>
                    <td width='70' class='title'>���Ա�</td>
                    <td width='80' class='title'>�Ұ�</td>
                    <td width='80' class='title'>û��</td>
                    <td width='70'  class='title'>������</td>               
                </tr>
            </table>
		</td>		
	</tr>
<%	if(ser_size > 0){%>
	<tr>		
        <td class='line' width='740' id='td_con' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
         <%for(int i = 0 ; i < ser_size ; i++){
				Hashtable exp = (Hashtable)sers.elementAt(i);				
				 file_path = AddUtil.replace(AddUtil.replace(AddUtil.replace(String.valueOf(exp.get("FILE_PATH")),"D:\\Inetpub\\wwwroot\\data\\",""),"D:\\Inetpub\\wwwroot\\data\\",""),"\\","/");             
				%>
                <tr> 
                    <td width='8%' align='center'>
                    <% if ( !exp.get("JUNG_ST").equals("������")) { %>
                    <a href="javascript:parent.view_jungsan('<%=exp.get("CAR_MNG_ID")%>', '<%=exp.get("SERV_ID")%>')" onMouseOver="window.status=''; return true"> <% } %> <%=i+1%>
                    <%if(exp.get("USE_YN").equals("N")){%>   	(�ؾ�) 
                  	<%}%>
                  	<% if ( !exp.get("JUNG_ST").equals("������")) { %> </a> <% } %>
                    </td>
                    <td width='6%' align='center'>
                    <%if(!exp.get("SCAN_FILE").equals("")){%>
            <!--                 <a href="<%=theURL%><%=file_path%><%=exp.get("SCAN_FILE")%><%=file_ext%>" target="SCAN"  title="�������� ���÷��� Ŭ���ϼ���" onclick="javascript:MM_openBrWindow('','SCAN','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=700,height=650,left=50, top=50')" ><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a> -->
        		<a href="javascript:view_map('<%=file_path%>', '<%=exp.get("SCAN_FILE")%>');" title="�������� ���÷��� Ŭ���ϼ���"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                   <% } %>                   
                    <td width='6%' align='center'><%=exp.get("JUNG_ST")%></td>
                    <td width='10%' align='center'><%=exp.get("SERV_ST")%></td>
                    <td width='5%' align='center'><%=exp.get("OUR_FAULT_PER")%></td> <!-- ��� -->
                    <td width='5%' align='center'><%=Math.abs(AddUtil.parseInt(String.valueOf(exp.get("OUR_FAULT_PER")))-100)%></td> <!-- ���� -->
                    <td width='5%' align='center'><%=exp.get("PIC_CNT")%></td>  <!-- ����-->
                    <td width='12%' align='center'><%=exp.get("CAR_NO")%></td>
                    <td width='16%' align='left'>&nbsp;<%=exp.get("CAR_NM")%></td>
                    <td width='11%' align='center'><%=exp.get("SERV_DT")%></td>
               
                </tr>
       <%		}%>
                <tr> 
                    <td colspan="10" class=title align=center>�հ�</td>
                </tr>
            </table>
        </td>
		<td class='line' width='1230'>			
			  <table border="0" cellspacing="1" cellpadding="0" width="1230" >
             <%for(int i = 0 ; i < ser_size ; i++){
				Hashtable exp = (Hashtable)sers.elementAt(i);
				
					// ���� ��� ���Ǻ���
				 int our_fault = 0;
				 String ch_fault = "";
				 String ch_acc_st = "";
				 
				 String o_fault= cs_db.getOutFaultPer( (String)exp.get("CAR_MNG_ID"), (String)exp.get("ACCID_ID"));
				
				 StringTokenizer token2 = new StringTokenizer(o_fault,"^");
				
				 while(token2.hasMoreTokens()) {
						ch_fault = token2.nextToken().trim();	 
						ch_acc_st = token2.nextToken().trim();	 			
				 }
				 our_fault = AddUtil.parseInt (ch_fault);
				 				 				 
				 int v_sup_amt = AddUtil.parseInt((String)exp.get("SUP_AMT")); //�������ް�
				
				 int v_amt = AddUtil.parseInt((String)exp.get("AMT")); //��ǰ
				 
				  int v_dc_sup_amt = AddUtil.parseInt((String)exp.get("DC_SUP_AMT")); //dc ���ް�
				 
				 if ( exp.get("SERV_ST").equals("�������")){   
				 	if (ch_acc_st.equals("4")) {
				 		v_amt = v_amt;
				    }else  {
				        v_amt = v_amt * our_fault/100;
				    }
				 }  
				    
				 int v_labor = AddUtil.parseInt((String)exp.get("LABOR")); //����
				 
						 
				if ( exp.get("SERV_ST").equals("�������")){   
				 	if (ch_acc_st.equals("4")) {
				 		v_labor = v_labor;
				    }else  {
				        v_labor = v_labor * our_fault/100;
				    }
   				 }  
				 	   
					 
				 int v_c_labor = AddUtil.parseInt((String)exp.get("A_LABOR")); //���� ���� ���� :õ����:dc���� 1~2õ����:10% 2~3õ����:15%, 3õ�����̻�:20%
				 				  
				 int v_cnt =  AddUtil.parseInt((String)exp.get("CNT"));
				 
				 int v_cust_amt =  AddUtil.parseInt((String)exp.get("CUST_AMT"));
				 int v_ext_amt =  AddUtil.parseInt((String)exp.get("EXT_AMT"));
				  int v_cls_amt =  AddUtil.parseInt((String)exp.get("CLS_AMT"));
				 
				 StringTokenizer token1 = new StringTokenizer((String)exp.get("ITEM"),"^");
				 
				 String item1 = "";
				 String item2 = "";
				   
			     while(token1.hasMoreTokens()) {
				
				  	 item1 = token1.nextToken().trim();	//
				   	 item2 = token1.nextToken().trim();	//��ǰ
								
			     }	
			     
			     
			    //���� ���� ���� :õ����:dc���� 1~2õ����:10% 2~3õ����:15%, 3õ�����̻�:20%
				  
			    if  ( i == 0 ) {
			   		amt[8]   = v_c_labor + v_labor ;	
			   	}else {
			   		amt[8]  = amt[8]  + v_labor;	
			   	}
			   
			  			    
			    int c_rate = 0;
			    int vc_rate = 0;
			    int jj_amt = 0;
				int jjj_amt = 0;
									
				long s_dt = 	AddUtil.parseLong(String.valueOf(exp.get("SS_DT")));
							
				// 2008�� 8�� ������ dc ����, ���� dc ���� ����
				if ( s_dt > 200808 || String.valueOf(exp.get("SSS_ST")).equals("0") ){
					 c_rate = 0;
				} else {
					if ( amt[8] > 10000000 &&  amt[8] <= 20000000 ) {
				         c_rate = 10;
				    } else if ( amt[8] > 20000000 &&  amt[8] <= 30000000 ) {
				         c_rate = 15;
				    } else if ( amt[8] >30000000 ) {
				         c_rate = 20;   
				    } else {
				         c_rate = 0;   
				    }           
				}
				
		
			    
			    if ( AddUtil.parseInt(t_wd) > 1 && i == 0) {
			        amt8_old = v_c_labor;  //1ȸ���̻��� ���
			    }
			    
			    //������ 0���� ū ���
			    if (v_labor > 0 ) {
				    //���� dc ������ �ɸ��� ��� 
				    if ( amt8_old < 10000000  && amt[8] > 10000000 &&  amt[8] <= 20000000 ) {
				     	 jj_amt = amt[8] - 10000000;
				    } else if (  amt8_old < 20000000  &&  amt[8] > 20000000 &&  amt[8] <= 30000000 ) {
				         jj_amt = amt[8] - 20000000;
				    } else if ( amt8_old < 30000000   && amt[8] >30000000 ) {
				         jj_amt = amt[8] - 30000000;
				    }
				    
				    
				    // 2õ����, 3õ���� ���� ������ ��� �ݾ� ����
				    if (  amt8_old < 20000000  &&  amt[8] > 20000000 &&  amt[8] <= 30000000 ) {
				         jjj_amt = (v_labor - jj_amt) * 10/100;
				    } else if ( amt8_old < 30000000   && amt[8] >30000000 ) {
				          jjj_amt = (v_labor - jj_amt) * 15/100;
				    }
			    }
			    
			   	// 2008�� 8�� 4�������� dc ����, ���� dc ���� ����
			    if ( s_dt > 200808 || String.valueOf(exp.get("SSS_ST")).equals("0") ){
			        vc_rate = 0;
			    } else {
				    if(v_labor != 0  )	vc_rate = v_labor*c_rate/100;
				    if(jj_amt !=0 )	  vc_rate = (jj_amt*c_rate/100) + jjj_amt;
			    } 
			      
			    String item3 = "";
			     
			    if (String.valueOf(exp.get("CNT")).equals("1")) {
  			         item3 = item2;
			  	}else {
			         item3 = item2 + " �� " +  AddUtil.parseDecimal(v_cnt - 1) + " ��";		  
			  	}
			  	
			  	amt8_old =  amt[8];
	%>		 
		
		        <tr>
		             <td width='80' align=center><%=exp.get("IPGODT")%></td>
	                      <td width='80' align=center><%=exp.get("CHULGODT")%></td>
	                      <td width='60' align='center'><%=c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER")%></td>			  
    			    <td width='170' align='left'>&nbsp;<%=Util.subData(String.valueOf(exp.get("CLIENT_NM")), 12)%></td>
      			    <td width='200' align='left'>&nbsp;
      			    <%if(String.valueOf(exp.get("CNT")).equals("1")){%>
      			    <%=item2 %>
    			  	<%}else{%>
    			   <%=Util.subData(item2, 10)%>&nbsp;�� <%= AddUtil.parseDecimal(v_cnt - 1)%>&nbsp;��		  
    			  	<%}%></td>
      			 <td width='80' align='right'><%=AddUtil.parseDecimal(exp.get("SUP_AMT"))%>&nbsp;</td>          
	                    <td width='80' align='right'><%=AddUtil.parseDecimal(v_labor - vc_rate)%>&nbsp;</td>
	                    <td width='80' align='right'><%=AddUtil.parseDecimal(v_amt)%>&nbsp;</td>
	                    <td width='60' align='right'><%=AddUtil.parseDecimal(v_dc_sup_amt)%>&nbsp;</td>
	                    <td width='70' align='right'><%=AddUtil.parseDecimal(v_ext_amt)%>&nbsp;&nbsp;</td>
	                    <td width='80' align='right'><%=AddUtil.parseDecimal(v_labor - vc_rate + v_amt - v_dc_sup_amt -  v_ext_amt  )%>&nbsp;</td>
	                    <td width='80' align='right'><%=AddUtil.parseDecimal(exp.get("CUST_AMT"))%>&nbsp;</td>
	                     <td width='70' align='right'><%=AddUtil.parseDecimal(exp.get("CLS_AMT"))%>&nbsp;</td>
	              
       <!--         <td width='40' align='center'>
                 <%if(String.valueOf(exp.get("SET_DT")).equals("")){%>
                <input type="checkbox" name="ch_all" value="<%=exp.get("SERV_ST")%>^<%=exp.get("CAR_MNG_ID")%>^<%=exp.get("SERV_ID")%>^<%=exp.get("CAR_NO")%>^<%=exp.get("CAR_NM")%>^<%=exp.get("CLIENT_NM")%>^<%=c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER_SA")%>^<%=c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER")%>^<%=item3%>^<%=v_labor - vc_rate%>^<%=exp.get("AMT")%>^<%=st_dt%>^<%=end_dt%>^" >
               	<%}else{%>
                - 
                <%}%></td> -->
                
                </tr>
               <%	
               
             		amt[0]   = amt[0] + v_labor;
             		amt[1]   = amt[1] + v_amt;
             		amt[2]   = amt[2] + v_amt + v_labor;
             		amt[3]   = amt[3] + vc_rate;
             		amt[4]   = amt[4] + v_labor- vc_rate;
             		amt[5]   = amt[5] + v_amt;
             		amt[6]   = amt[6] + v_labor - vc_rate + v_amt  - v_dc_sup_amt  - v_ext_amt;
             		amt[7]   = amt[7] + v_cust_amt;
             		amt[9]   = amt[9] + v_sup_amt;
             		
             		amt[10]   = amt[10] + v_dc_sup_amt;  //dc ���ް�
             		
             		amt[11]   = amt[11] + v_ext_amt;
             		
             		amt[12]   = amt[12] + v_cls_amt;
      			               
               	}%>
         	    <tr> 
                    <td class=title colspan=5></td>
                    <td width='80' class=title style='text-align:right'><%=Util.parseDecimal(amt[9] )%>&nbsp;</td>    		
                    <td width='80' class=title style='text-align:right'><%=Util.parseDecimal(amt[4] )%>&nbsp;</td>
                    <td width='80' class=title style='text-align:right'><%=Util.parseDecimal(amt[5] )%>&nbsp;</td>
                    <td width='60' class=title style='text-align:right'><%=Util.parseDecimal(amt[10] )%>&nbsp;</td>
                    <td width='70' class=title style='text-align:right'><%=Util.parseDecimal(amt[11] )%>&nbsp;</td>
                    <td width='80' class=title style='text-align:right'><%=Util.parseDecimal(amt[6] )%>&nbsp;</td>
                    <td width='80' class=title style='text-align:right'><%=Util.parseDecimal(amt[7] )%>&nbsp;</td>
                    <td width='70' class=title style='text-align:right'><%=Util.parseDecimal(amt[12] )%>&nbsp;</td>
                </tr>
            </table>
		</td>
	</tr>	
<%	}else{%>
	<tr>		
        <td class='line' width='740' id='td_con' style='position:relative;'> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='1230'>			
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
		    </table>
	    </td>
	</tr>
<%	} %>
</table>
</form>
</body>
</html>
