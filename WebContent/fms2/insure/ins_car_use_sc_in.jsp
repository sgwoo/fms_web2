<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String print_yn = request.getParameter("print_yn")==null?"":request.getParameter("print_yn");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt1 =0;
	int cnt2 =0;
	int cnt3 =0;
	int cnt4 =0;
	int cnt5 =0;
	int cnt6 =0;
	int cnt7 =0;
	int cnt8 =0;
	int cnt9 =0;
	int cnt10 =0;
	int cnt11 =0;
	int cnt12 =0;
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector vt = ai_db.getInsureStatSearchList(gubun1, "1");
	int vt_size = vt.size();
	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
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
	function init() {
		
		setupEvents();
	}
	
	//����Ʈ�ϱ�
	function stat_print(){
		window.open("ins_car_use_sc_in.jsp?gubun1=<%=gubun1%>&print_yn=Y","print","left=30,top=50,width=950,height=600,scrollbars=yes");	
	}
	
	//����
	function stat_excel(){
		window.open("ins_car_use_sc_in_excel.jsp?gubun1=<%=gubun1%>&print_yn=Y","print","left=30,top=50,width=950,height=600,scrollbars=yes");	
	}

	//���θ���Ʈ
	function view_ins(gubun1, car_use, s_st, age_st, cnt){
		if(cnt==0){
			 alert('����Ʈ�� �����ϴ�.'); return;
		}else{
			window.open('view_ins_list.jsp?gubun1='+gubun1+'&car_use='+car_use+'&s_st='+s_st+'&age_st='+age_st, "STAT_INS_LIST", "left=0, top=0, width=1000, height=768, scrollbars=yes, status=yes, resize");
		}
	}
	
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%if(print_yn.equals("Y")){%>
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,4,438,06"> 
</object> 
<%}%>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
<%if(print_yn.equals("Y")){%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������Ȳ > <span class=style5><%if(gubun1.equals("1")){%>������<%}else{%>������<%}%> ���谡����Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr><td class=h></td></tr>
     <tr>   
<%}%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ǻ����� �Ƹ���ī</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class='line' width='100%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='14%' class='title'>����</td>
		    <td width='14%' class='title'>����</td>
		    <td width='9%' class='title'>�Һз�����</td>				
		    <td width='6%' class='title'>�ѰǼ�</td>				
		    <td width='4%' class='title'>21��</td>				
		    <td width='4%' class='title'>22��</td>				
		    <td width='5%' class='title'>24��</td>				
		    <td width='5%' class='title'>26��</td>				
		    <td width='4%' class='title'>28��</td>				
		    <td width='4%' class='title'>30��</td>				
		    <td width='5%' class='title'>35��</td>				
		    <td width='6%' class='title'>35��~49��</td>				
		    <td width='4%' class='title'>43��</td>				
		    <td width='4%' class='title'>48��</td>				
		    <td width='5%' class='title'>��翬��</td>				
		    <td width='7%' class='title'>26�������</td>				
		</tr>    
	    </table>
	</td>
    </tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='100%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			cnt1 	= cnt1 + AddUtil.parseInt(String.valueOf(ht.get("CNT")));
			cnt2 	= cnt2 + AddUtil.parseInt(String.valueOf(ht.get("AGE_21_CNT")));
			cnt3 	= cnt3 + AddUtil.parseInt(String.valueOf(ht.get("AGE_24_CNT")));
			cnt4 	= cnt4 + AddUtil.parseInt(String.valueOf(ht.get("AGE_26_CNT")));
			cnt5 	= cnt5 + AddUtil.parseInt(String.valueOf(ht.get("AGE_30_CNT")));
			cnt6 	= cnt6 + AddUtil.parseInt(String.valueOf(ht.get("AGE_35_CNT")));
			cnt7 	= cnt7 + AddUtil.parseInt(String.valueOf(ht.get("AGE_43_CNT")));
			cnt8 	= cnt8 + AddUtil.parseInt(String.valueOf(ht.get("AGE_48_CNT")));
			cnt9 	= cnt9 + AddUtil.parseInt(String.valueOf(ht.get("AGE_ETC_CNT")));
			cnt10 	= cnt10 + AddUtil.parseInt(String.valueOf(ht.get("AGE_22_CNT")));
			cnt11 	= cnt11 + AddUtil.parseInt(String.valueOf(ht.get("AGE_28_CNT")));
			cnt12 	= cnt12 + AddUtil.parseInt(String.valueOf(ht.get("AGE_3549_CNT")));

%>
				<tr>
					<td width='14%' align='center'><%=ht.get("GUBUN")%></td>
					<td width='14%' align='center'>
					    <%      if(String.valueOf(ht.get("GUBUN")).equals("�¿����A")){%>���,����ũ
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("�¿����B")){%>�ƹݶ�,K3
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("�¿�����")){%>�Ÿ,K5
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("�¿����")){%>�׷���,K7
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6�ν� ¤ 1600cc ����")){%>QM3,Ƽ����
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6�ν� ¤ 2000cc ����")){%>����,����Ƽ��,��Ÿ��,���
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6�ν� ¤ 2000cc �ʰ�")){%>�ƽ�ũ����,��Ÿ��,���
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("7�ν� 2000cc ����")){%>��Ÿ��,���
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("7�ν� 2000cc �ʰ�")){%>�ƽ�ũ����,��Ÿ��,���
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("9�ν�")){%>ī�Ϲ�,�ڶ���,��������
					    <%}else {%><%=ht.get("CAR")%>
					    <%}%>										
					</td>
					<td width='9%' align='center'><%=ht.get("S_ST_CD")%></td>
					<td width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_21_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','1','<%=ht.get("AGE_21_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_22_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','9','<%=ht.get("AGE_22_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>						
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_24_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','4','<%=ht.get("AGE_24_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_26_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','2','<%=ht.get("AGE_26_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_28_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','10','<%=ht.get("AGE_28_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_30_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','5','<%=ht.get("AGE_30_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_35_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','6','<%=ht.get("AGE_35_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_3549_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','11','<%=ht.get("AGE_3549_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_43_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','7','<%=ht.get("AGE_43_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_48_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','8','<%=ht.get("AGE_48_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_ETC_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','1','<%=ht.get("S_ST_CD")%>','3','<%=ht.get("AGE_ETC_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='7%' align='right'><%=AddUtil.parseDecimal(ai_db.getInsureStatSearchListAmt(gubun1, "1", String.valueOf(ht.get("S_ST_CD")), "2"))%></td>
				</tr>
<%
		}
%>
                <tr> 
                    <td class="title" colspan='3'>�հ�</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt1)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt2)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt10)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt3)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt4)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt11)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt5)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt6)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt12)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt7)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt8)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt9)%></td>
                    <td class="title"></td>
                    
                </tr>	
			</table>
		</td>
    </tr>		
		
<%                     
	}                  
%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ǻ����� ��</span></td>
    </tr>
    
    
    <%		vt = ai_db.getInsureStatSearchList(gubun1, "2");
		vt_size = vt.size();
		cnt1 =0;
		cnt2 =0;
		cnt3 =0;
		cnt4 =0;
		cnt5 =0;
		cnt6 =0;
		cnt7 =0;
		cnt8 =0;
		cnt9 =0;
		cnt10 =0;
		cnt11 =0;
		cnt12 =0;
    %>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class='line' width='100%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='14%' class='title'>����</td>
		    <td width='14%' class='title'>����</td>
		    <td width='9%' class='title'>�Һз�����</td>				
		    <td width='6%' class='title'>�ѰǼ�</td>				
		    <td width='4%' class='title'>21��</td>				
		    <td width='4%' class='title'>22��</td>				
		    <td width='5%' class='title'>24��</td>				
		    <td width='5%' class='title'>26��</td>				
		    <td width='4%' class='title'>28��</td>				
		    <td width='4%' class='title'>30��</td>				
		    <td width='5%' class='title'>35��</td>				
		    <td width='6%' class='title'>35��~49��</td>				
		    <td width='4%' class='title'>43��</td>				
		    <td width='4%' class='title'>48��</td>				
		    <td width='5%' class='title'>��翬��</td>				
		    <td width='7%' class='title'>�����</td>				
		</tr>    
	    </table>
	</td>
    </tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='100%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		String max_cnt_age = "";
		String max_cnt_age_nm = "";
		int max_cnt = 0;
		
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			max_cnt = 0;
			max_cnt_age = "";
			max_cnt_age_nm = "";
			
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_21_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_21_CNT")));
				max_cnt_age = "1";
				max_cnt_age_nm = "21��";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_22_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_22_CNT")));
				max_cnt_age = "9";
				max_cnt_age_nm = "22��";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_24_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_24_CNT")));
				max_cnt_age = "4";
				max_cnt_age_nm = "24��";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_26_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_26_CNT")));
				max_cnt_age = "2";
				max_cnt_age_nm = "26��";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_28_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_28_CNT")));
				max_cnt_age = "10";
				max_cnt_age_nm = "28��";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_30_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_30_CNT")));
				max_cnt_age = "5";
				max_cnt_age_nm = "30��";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_35_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_35_CNT")));
				max_cnt_age = "6";
				max_cnt_age_nm = "35��";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_3549_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_3549_CNT")));
				max_cnt_age = "11";
				max_cnt_age_nm = "35~49��";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_43_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_43_CNT")));
				max_cnt_age = "7";
				max_cnt_age_nm = "43��";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_48_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_48_CNT")));
				max_cnt_age = "8";
				max_cnt_age_nm = "48��";
			}
			if(max_cnt < AddUtil.parseInt(String.valueOf(ht.get("AGE_ETC_CNT")))){
				max_cnt = AddUtil.parseInt(String.valueOf(ht.get("AGE_ETC_CNT")));
				max_cnt_age = "3";
				max_cnt_age_nm = "��翬��";
			}
			
			
			cnt1 	= cnt1 + AddUtil.parseInt(String.valueOf(ht.get("CNT")));
			cnt2 	= cnt2 + AddUtil.parseInt(String.valueOf(ht.get("AGE_21_CNT")));
			cnt3 	= cnt3 + AddUtil.parseInt(String.valueOf(ht.get("AGE_24_CNT")));
			cnt4 	= cnt4 + AddUtil.parseInt(String.valueOf(ht.get("AGE_26_CNT")));
			cnt5 	= cnt5 + AddUtil.parseInt(String.valueOf(ht.get("AGE_30_CNT")));
			cnt6 	= cnt6 + AddUtil.parseInt(String.valueOf(ht.get("AGE_35_CNT")));
			cnt7 	= cnt7 + AddUtil.parseInt(String.valueOf(ht.get("AGE_43_CNT")));
			cnt8 	= cnt8 + AddUtil.parseInt(String.valueOf(ht.get("AGE_48_CNT")));
			cnt9 	= cnt9 + AddUtil.parseInt(String.valueOf(ht.get("AGE_ETC_CNT")));
			cnt10 	= cnt10 + AddUtil.parseInt(String.valueOf(ht.get("AGE_22_CNT")));
			cnt11 	= cnt11 + AddUtil.parseInt(String.valueOf(ht.get("AGE_28_CNT")));
			cnt12 	= cnt12 + AddUtil.parseInt(String.valueOf(ht.get("AGE_3549_CNT")));


%>
				<tr>
					<td width='14%' align='center'><%=ht.get("GUBUN")%></td>
					<td width='14%' align='center'>
					    <%      if(String.valueOf(ht.get("GUBUN")).equals("�¿����A")){%>���,����ũ
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("�¿����B")){%>�ƹݶ�,K3
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("�¿�����")){%>�Ÿ,K5
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("�¿����")){%>�׷���,K7
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6�ν� ¤ 1600cc ����")){%>QM3,Ƽ����
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6�ν� ¤ 2000cc ����")){%>����,����Ƽ��,��Ÿ��,���
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6�ν� ¤ 2000cc �ʰ�")){%>�ƽ�ũ����,��Ÿ��,���
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("7�ν� 2000cc ����")){%>��Ÿ��,���
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("7�ν� 2000cc �ʰ�")){%>�ƽ�ũ����,��Ÿ��,���
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("9�ν�")){%>ī�Ϲ�,�ڶ���,��������
					    <%}else {%><%=ht.get("CAR")%>
					    <%}%>					
					</td>
					<td width='9%' align='center'><%=ht.get("S_ST_CD")%></td>
					<td width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_21_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','1','<%=ht.get("AGE_21_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_22_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','9','<%=ht.get("AGE_22_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_24_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','4','<%=ht.get("AGE_24_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_26_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','2','<%=ht.get("AGE_26_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_28_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','10','<%=ht.get("AGE_28_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_30_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','5','<%=ht.get("AGE_30_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_35_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','6','<%=ht.get("AGE_35_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='6%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_3549_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','11','<%=ht.get("AGE_3549_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_43_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','7','<%=ht.get("AGE_43_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_48_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','8','<%=ht.get("AGE_48_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_ETC_CNT")))%><%if(!print_yn.equals("Y")){%><a href="javascript:view_ins('<%=gubun1%>','2','<%=ht.get("S_ST_CD")%>','3','<%=ht.get("AGE_ETC_CNT")%>')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a><%}%></td>
					<td width='7%' align='right'><%//=AddUtil.parseDecimal(String.valueOf(ht.get("G_2")))%>(<%=max_cnt_age_nm%>)<%=AddUtil.parseDecimal(ai_db.getInsureStatSearchListAmt(gubun1, "2", String.valueOf(ht.get("S_ST_CD")), max_cnt_age))%></td>
				</tr>
<%
		}
%>
                <tr> 
                    <td class="title" colspan='3'>�հ�</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt1)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt2)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt10)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt3)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt4)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt11)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt5)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt6)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt12)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt7)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt8)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt9)%></td>
                    <td class="title"></td>
                </tr>	
	    </table>
	</td>
    </tr>		
		
<%                     
	}                  
%>
    <%if(!print_yn.equals("Y")){%>
    </tr>
	<tr><td class=h></td></tr>
     <tr>       
    <tr>
        <td align='right'>
           <a href='javascript:stat_print()' title='����Ʈ�ϱ�'><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a> 
           
           <a href='javascript:stat_excel()' title='����Ʈ�ϱ�'><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
            </td>
    </tr>       
    <%}%>
</table>
<script language='javascript'>
<!--
<%if(print_yn.equals("Y")){%>
onprint();

function onprint(){
	factory.printing.header 	= ""; //��������� �μ�
	factory.printing.footer 	= ""; //�������ϴ� �μ�
	factory.printing.portrait 	= false; //true-�����μ�, false-�����μ�    
	factory.printing.leftMargin 	= 10.0; //��������   
	factory.printing.rightMargin 	= 10.0; //��������
	factory.printing.topMargin 	= 10.0; //��ܿ���    
	factory.printing.bottomMargin 	= 10.0; //�ϴܿ���
	factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
<%}%>	
//-->
</script>
</body>
</html>
