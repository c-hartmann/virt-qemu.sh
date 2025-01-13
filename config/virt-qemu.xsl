<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	id="virt_qemu">

	<xsl:output
		method="text"
		encoding="UTF-8"
		omit-xml-declaration="yes"
		indent="yes"
	/>

	<xsl:template match="/domain">
		<!-- WE HAVE TO START WITH THE BINARY -->
		<xsl:value-of select="devices/emulator"/>
		<!-- SHALL WE USE -accel name= value-of type attribute instead? -->
<!-- 			<xsl:text> -enable-kvm </xsl:text> -->
		<xsl:if test="@type">
			<xsl:text> -machine accel=</xsl:text>
			<xsl:value-of select="@type"/>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

    <xsl:template match="name">
		<xsl:text> -name </xsl:text>
		<xsl:value-of select="."/>
	</xsl:template>

    <xsl:template match="uuid">
		<xsl:text> -uuid </xsl:text>
		<xsl:value-of select="."/>
	</xsl:template>

	<!-- allowed to use -m option twice? -->
    <xsl:template match="memory">
		<xsl:text> -m maxmem=</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>K</xsl:text>
	</xsl:template>

    <xsl:template match="currentMemory">
		<xsl:text> -m size=</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>K</xsl:text>
	</xsl:template>

    <xsl:template match="os/type[@arch='x86_64']">
		<xsl:text> -machine </xsl:text>
		<xsl:value-of select="@machine"/>
	</xsl:template>

    <xsl:template match="vcpu">
		<!-- cpus or cores? -->
		<xsl:text> -smp cpus=</xsl:text>
		<xsl:value-of select="."/>
	</xsl:template>

    <xsl:template match="cpu">
		<xsl:if test="@mode='host-passthrough'">
			<xsl:text> -cpu host </xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- for each here? -->
    <xsl:template match="devices/disk[@device='disk']/source">
		<xsl:text> -hda </xsl:text>
		<xsl:value-of select="@file"/>
	</xsl:template>

    <xsl:template match="devices/disk[@device='cdrom']/source">
		<xsl:text> -cdrom </xsl:text>
		<xsl:value-of select="@file"/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<!-- allowed to use -boot option twice? -->
    <xsl:template match="os/bootmenu">
		<xsl:choose>
			<xsl:when test="@enable='yes'">
				<xsl:text> -boot menu=on </xsl:text>
			</xsl:when>
			<xsl:when test="@enable='no'">
				<xsl:text> -boot menu=off </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

    <xsl:template match="os/boot[@dev='hd']">
		<xsl:text> -boot c </xsl:text>
	</xsl:template>

    <xsl:template match="os/boot[@dev='cdrom']"><!-- valid attribute? -->
		<xsl:text> -boot d </xsl:text>
	</xsl:template>

	<!-- user network interface is default. -nic user valid? -->
<!--	<xsl:template match="interface">
			<xsl:if test="@type='user'">
				<xsl:variable name="id" select="'net0'" />
				<xsl:text> -netdev </xsl:text>
				<xsl:value-of select="@type"/>
				<xsl:text>,id=</xsl:text>
				<xsl:copy-of select="$id" />
				<xsl:text> -device virtio-net-pci,netdev=</xsl:text>
				<xsl:copy-of select="$id" />
			</xsl:if>
	</xsl:template>-->

    <xsl:template match="sound">
		<xsl:choose>
			<xsl:when test="@model='ich9'">
<!--					<xsl:text> -device ich9-intel-hda,id=snd0 </xsl:text>
				<xsl:text> -device hda-output,audiodev=snd0 </xsl:text>-->
				<xsl:text> -device ich9-intel-hda </xsl:text>
				<xsl:text> -device hda-output </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- ignore anything else -->
	<xsl:template match="text()"/>

</xsl:stylesheet>
